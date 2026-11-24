%% Modulator runs after the chopper fix: in-band floor against the ideal model and the first design
% The records (about 13 ms, 26000 samples) are not coherent with the input, so a Blackman-Harris window is
% used and the signal leakage limits the SNDR (about 89 dB even for the ideal model, which gives 115.5 dB over
% 65536 samples). The circuit is therefore compared with the ideal model on a record of the same length.
% The 3-6 kHz floor (shaped quantization noise still small there) is reported as a second, rough indicator:
%   SNDR ~ P_signal / (floor * BW), floor assumed flat in the band, P_signal = amp^2/2 for a +-1 bit stream
% (this gives only 91.8 dB for the ideal model). For a coherent record use analyze_modulator_psd.m.
clear; clc; close all;

root  = fileparts(mfilename('fullpath'));
files = {'dsm_noise_Non.txt',          'First design, no noise (before fix)';
         'dsm_noise_Non_latest.txt',   'Fixed chopper, no noise, 3.7 ms';
         'dsm_noise_NoNo_lastest.txt', 'Fixed chopper, noise injected, 3.7 ms';
         'dsm_noise_OFF.txt',          'Fixed chopper, no noise, 13 ms';
         'dsm_noise_ON.txt',           'Fixed chopper, noise injected, 13 ms'};
fs    = 2.048e6;   fin = 343.75;  amp = 0.5;        % input amplitude relative to full scale (-6 dBFS)
s1 = 0.3;  s2 = 0.18;  thr = 0.9;                   % ideal-model scaling, DFF bit decision level
fb = [3e3 6e3];  bw = 2e3;  n_skip = 1000;       % floor band, signal band, start-up cycles to discard
fsm = 2e4;                                          % smooth only above this frequency (below it the bins are wide and a window would smear the tone)
blue = [0 0.447 0.741];  red = [0.85 0.33 0.1];  gry = [0.55 0.55 0.55];  dk = [0.2 0.2 0.2];
cols = {red, [0.6 0.8 0.95], [0.75 0.9 0.6], blue, [0.47 0.67 0.19]};   % light = 3.7 ms runs, dark = 13 ms runs
set(0, 'DefaultAxesFontName', 'Arial', 'DefaultAxesFontSize', 12);

%% Load, spectrum, floor
nf = size(files, 1);  F = cell(nf, 1);  P = cell(nf, 1);  fl = zeros(nf, 1);  nn = zeros(nf, 1);  V = cell(nf, 1);
for c = 1:nf
    d = readmatrix(fullfile(root, '..', 'results', files{c, 1}));
    v = 2 * (d(:, 2) > thr) - 1;  v = v(n_skip+1:end);
    V{c} = v;  [F{c}, P{c}] = psd_bits(v, fs);
    fl(c) = mean(P{c}(F{c} > fb(1) & F{c} < fb(2)));  nn(c) = numel(v);
end

% ideal model with the same input and the same length as the last file (13 ms)
u = amp * sin(2*pi*fin/fs * (0:nn(end)+2000-1));
xi = mod2_sim(u, s1, s2);  xi = xi(2001:end).';
[Fi, Pi] = psd_bits(xi, fs);
fli = mean(Pi(Fi > fb(1) & Fi < fb(2)));

%% Report
Ps = amp^2 / 2;                                      % signal power of the +-1 bit stream
fprintf('%-32s %8s %14s %10s %12s\n', 'run', 'samples', 'floor 3-6k', 'vs ideal', 'SNDR(floor)');
for c = 1:nf
    fprintf('%-32s %8d %11.2e   %9.1fx %9.1f dB\n', files{c, 2}, nn(c), fl(c), fl(c)/fli, 10*log10(Ps/(fl(c)*bw)));
end
fprintf('%-32s %8d %11.2e   %9.1fx %9.1f dB\n', 'Ideal model (same input)', numel(xi), fli, 1, 10*log10(Ps/(fli*bw)));
fprintf('\nSNDR in 0-%d Hz, Blackman-Harris, signal at the nominal fin (bins +-4), ideal model on a record of the same length:\n', bw);
for c = 1:nf
    fq = fin;                                        % nominal input frequency of the testbench
    ui = amp * sin(2*pi*fq/fs * (0:nn(c)+2000-1));  xc = mod2_sim(ui, s1, s2);  xc = xc(2001:end).';
    fprintf('%-32s fin %.2f Hz | circuit %6.2f dB | ideal %6.2f dB\n', files{c, 2}, fq, sndr_bh(V{c}, fs, fq, bw), sndr_bh(xc, fs, fq, bw));
end
fprintf('\nFloor reduction of the fix (no noise): %.0f times\n', fl(1) / fl(2));

%% Figure: PSD with the floor band
fig = figure('Color', 'w', 'Position', [100 100 1000 480]);
loglog(Fi(2:end), smooth_hi(Fi, Pi, fsm), 'Color', gry, 'LineWidth', 1.6); hold on;
show = [1 4 5];                                      % curves in the figure (README): first design and the 13 ms runs; use 1:nf for all
for c = show
    loglog(F{c}(2:end), smooth_hi(F{c}, P{c}, fsm), 'Color', cols{c}, 'LineWidth', 1.3);
end
xline(fb, '--', 'Color', dk);  xline(bw, ':', 'Color', dk);
grid on; box off; xlim([100 fs/2]); xlabel('Frequency (Hz)'); ylabel('PSD (FS^2/Hz, +-1 bit stream)');
legend([{'Ideal model'}; files(show, 2)], 'Location', 'southeast', 'Box', 'off');
title('Output PSD (smoothed above 20 kHz); dashed: floor band 3-6 kHz, dotted: 2 kHz');
exportgraphics(fig, fullfile(root, '..', 'docs', 'figures', 'psd_fixed.png'), 'Resolution', 150);

%% ---------------- local functions ----------------
function sn = sndr_bh(x, fs, fin, bw)
% SNDR with a Blackman-Harris window: signal = bins fin +-4, noise = 0..bw without DC and the signal.
    x = x(:);  n = numel(x);  hw = 4;
    P = abs(fft(x .* blackmanharris(n))).^2;  P = P(1:floor(n/2)+1);
    df = fs / n;  k = round(fin / df) + 1;
    lo = max(1, k-hw);  m = false(size(P));  m(hw+2 : floor(bw/df)+1) = true;  m(lo:k+hw) = false;
    if ~any(m), sn = NaN; return; end                         % no noise bin left (record too short)
    sn = 10 * log10(sum(P(lo:k+hw)) / sum(P(m)));
end

function y = smooth_hi(f, P, fsm)
% Moving average over 15 bins above fsm only; the points below fsm are returned unchanged (index 1 = DC is dropped).
    y = P(2:end);  f = f(2:end);  m = f > fsm;
    y(m) = movmean(y(m), 15);
end

function [f, P] = psd_bits(x, fs)
% One-sided PSD of the bit stream (Blackman-Harris window), in FS^2/Hz with FS = 1 for +-1 bits.
    x = x(:);  n = numel(x);  w = blackmanharris(n);
    X = fft(x .* w);  X = X(1:floor(n/2)+1);
    P = abs(X).^2 * 2 / (fs * sum(w.^2));
    f = (0:floor(n/2)).' * fs / n;
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
