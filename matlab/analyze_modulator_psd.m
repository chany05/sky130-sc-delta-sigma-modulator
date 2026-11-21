%% Modulator output spectrum, SNDR and comparison with the ideal behavioral model
% Reads ../results/modulator/<file> (ngspice wrdata: time, DFF output voltage, one row per clock cycle).
% The simulation includes device noise (trnoise), so the measured SNDR is the noisy one.
%
% Two SNDR estimates are made for the in-band noise (0 to bw):
%   A) direct: Blackman-Harris window on the full bitstream.
%   B) filtered: sinc^3 (x32) + Kaiser FIR low-pass whose passband ends at the sensor BW (f_b = 1.5 kHz) and whose
%      stopband starts at 2 kHz (0.5 kHz transition, as in the spec), then x4 decimation. The filter removes the
%      out-of-band shaped noise and the chopper noise (around f_s/2) before the FFT, so they cannot leak into the band,
%      and the filter transient is discarded. Needs the Signal Processing Toolbox (kaiserord, fir1).
% The ideal model is the same scaled 2nd-order CIFB loop as in behav_model.m, driven by the same sine.
clear; clc; close all;

root  = fileparts(mfilename('fullpath'));
fname = 'dsm_noise_32ms.txt';                % 32ms: with the 343.75 Hz input (run the other files the same way)
fs    = 2.048e6;   N = 65536;   kin = 11;    % coherent sampling: fin = kin*fs/N
fin   = kin * fs / N;
amp   = 0.6 / 1.2;                           % input amplitude relative to full scale (-6 dBFS)
s1 = 0.3;  s2 = 0.18;                        % scaling of the ideal model (same as the transistor-level circuit)
thr   = 0.9;                                 % bit decision level of the DFF output (VDD/2)
bw_list = [2000 1500];                       % noise bands to report [Hz]
blue = [0 0.447 0.741];  gry = [0.55 0.55 0.55];
set(0, 'DefaultAxesFontName', 'Arial', 'DefaultAxesFontSize', 12);

%% Load the bitstream (last N cycles, so the start-up is skipped)
d = readmatrix(fullfile(root, '..', 'results', 'modulator', fname));
v = 2 * (d(:, 2) > thr) - 1;                 % +-1
x_sp = v(end-N+1:end);                       % transistor level
fprintf('%s: %d samples, %d used, mean %.4f\n', fname, numel(v), N, mean(x_sp));

%% Ideal model with the same input
n_pre = 2000;
u = amp * sin(2*pi*kin/N * (0:N+n_pre-1));
x_id = mod2_sim(u, s1, s2);
x_id = x_id(n_pre+1:end).';

%% A) direct windowed FFT
fprintf('\n--- A) direct (Blackman-Harris, full rate) ---\n');
for bw = bw_list
    [s_sp, nse_sp] = sndr_fft(x_sp, fs, fin, bw);
    [s_id, ~]      = sndr_fft(x_id, fs, fin, bw);
    fprintf('BW %4d Hz : transistor %.2f dB (ENOB %.2f) | ideal %.2f dB\n', bw, s_sp, (s_sp-1.76)/6.02, s_id);
end

%% B) filtered + decimated
M1 = 32;  M2 = 4;  fs2 = fs / M1;  fs3 = fs2 / M2;
[nord, Wn, beta, ftype] = kaiserord([1500 2000], [1 0], [1e-4 10^(-90/20)], fs2);
h = fir1(nord, Wn, ftype, kaiser(nord + 1, beta), 'noscale');
dec = @(x) filter_dec(x, M1, M2, h);
y_sp = dec(x_sp);   y_id = dec(x_id);
fprintf('\n--- B) filtered (sinc^3 x%d, FIR %d taps, x%d) : %d samples at %.0f Hz ---\n', M1, nord+1, M2, numel(y_sp), fs3);
for bw = bw_list
    [s_sp, ~] = sndr_fft(y_sp, fs3, fin, bw);
    [s_id, ~] = sndr_fft(y_id, fs3, fin, bw);
    fprintf('BW %4d Hz : transistor %.2f dB (ENOB %.2f) | ideal %.2f dB\n', bw, s_sp, (s_sp-1.76)/6.02, s_id);
end

%% Figures: spectrum overlay (full rate) and in-band zoom (filtered record)
[f1, P_sp] = spec_dbfs(x_sp, fs);   [~, P_id] = spec_dbfs(x_id, fs);
figure('Color', 'w', 'Position', [100 100 1100 440]);
subplot(1,2,1);
semilogx(f1(2:end), movmean(P_id(2:end), 25), 'Color', gry, 'LineWidth', 1.4); hold on;   % smoothed for readability
semilogx(f1(2:end), movmean(P_sp(2:end), 25), 'Color', blue, 'LineWidth', 1.4);
xline([1500 2000], '--k'); grid on; box off; xlim([20 fs/2]); ylim([-160 0]);
xlabel('Frequency (Hz)'); ylabel('Magnitude (dBFS per bin)'); title('Output spectrum');
legend({'Ideal model', 'Transistor level (noise)'}, 'Location', 'southwest', 'Box', 'off');
[f2, Q_sp] = spec_dbfs(y_sp, fs3);  [~, Q_id] = spec_dbfs(y_id, fs3);
subplot(1,2,2);
plot(f2, Q_id, 'Color', gry, 'LineWidth', 1.4); hold on; plot(f2, Q_sp, 'Color', blue, 'LineWidth', 1.4);
xline([1500 2000], '--k'); grid on; box off; xlim([0 3000]); ylim([-160 0]);
xlabel('Frequency (Hz)'); title('In-band (after the decimation filter)');
exportgraphics(gcf, fullfile(root, '..', 'docs', 'figures', 'psd_overlay.png'), 'Resolution', 150);

%% ---------------- local functions ----------------
function [sn, nse] = sndr_fft(x, fs, fin, bw)
% SNDR with a Blackman-Harris window; the signal is the bins around fin, the noise is 0..bw without DC and the signal.
    x = x(:);  n = numel(x);  hw = 5;
    w = blackmanharris(n);  X = fft(x .* w);  P = abs(X(1:floor(n/2)+1)).^2;
    df = fs / n;  k = round(fin / df) + 1;                    % +1: MATLAB index of the bin
    sig = sum(P(k-hw:k+hw));
    m = false(size(P));  m(hw+2 : floor(bw/df)+1) = true;  m(k-hw:k+hw) = false;
    nse = sum(P(m));                                          % bin sums of both are Parseval-consistent (no ENBW factor)
    sn  = 10 * log10(sig / nse);
end

function [f, Pdb] = spec_dbfs(x, fs)
    x = x(:);  n = numel(x);  w = blackmanharris(n);
    X = fft(x .* w);  X = X(1:floor(n/2)+1);
    Pdb = 20 * log10(abs(X) * 2 / sum(w) + eps);              % 0 dBFS = sine with amplitude 1
    f = (0:floor(n/2)).' * fs / n;
end

function y = filter_dec(x, M1, M2, h)
% sinc^3 decimation by M1, FIR low-pass, decimation by M2. The filter transient is discarded ('valid').
    x = x(:);
    for i = 1:3
        c = [0; cumsum(x)];  x = (c(M1+1:end) - c(1:end-M1)) / M1;      % moving average of length M1
    end
    x = x(1:M1:end);
    y = conv(x, h(:), 'valid');
    y = y(1:M2:end);
end

function v = mod2_sim(u, s1, s2)
% Behavioral 2nd-order CIFB modulator with a 1-bit quantizer (same as behav_model.m).
    N = numel(u);  v = zeros(1, N);  a1 = 0;  a2 = 0;
    for i = 1:N
        v(i) = 2*(a2 >= 0) - 1;
        x1 = a1;
        a1 = a1 + s1*u(i) - s1*v(i);
        a2 = a2 + (s2/s1)*x1 - 2*s2*v(i);
    end
end
