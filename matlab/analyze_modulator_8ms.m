%% SNDR of the coherent 8 ms / 375 Hz modulator runs (fixed chopper)
% Inputs: ../results/modulator/Noise_off/dsm8ms_s*.txt and ../results/modulator/Noise_on/dsm8ms_s*.txt
%         (ngspice wrdata, one row per clock cycle: t, DFF output). The runs without noise are deterministic
%         and identical, so only the first one is used. The runs with noise use different seeds.
% Method: the last row of each file is a duplicate end point (1 ns after the previous row) and is dropped.
%         The last N = 16384 samples are used with a Hann window. The 375 Hz fundamental and DC are removed
%         with a Hann-weighted least-squares fit, and the residual is integrated from bin 1 to 2 kHz
%         (125 Hz bins). No window at all is not an option: 375 Hz is not exactly coherent with the 488.28 ns
%         clock period (3 fs / N = 375.00096 Hz), which limits even the ideal model to about 93 dB.
%         The ideal 2nd-order model is analyzed the same way for several input phases.
clear; clc; close all;
root = fileparts(mfilename('fullpath'));
din  = fullfile(root, '..', 'results', 'modulator');
out  = fullfile(root, '..', 'docs', 'figures');

T = 488.28e-9;  fs = 1 / T;  N = 16384;  fin = 375;  bw = 2e3;  amp = 0.5;   % amp relative to full scale (-6 dBFS)
s1 = 0.3;  s2 = 0.18;  thr = 0.9;                                           % ideal-model scaling, bit decision level
n  = (0:N-1).';  w = 0.5 - 0.5 * cos(2*pi*n/N);                              % periodic Hann
A  = [cos(2*pi*fin*T*n), sin(2*pi*fin*T*n), ones(N, 1)];
nb = round(bw / (fs / N));  f = (0:N/2).' * fs / N;
FS = 1.2;                                                                   % full scale in volts (differential peak)

cases = {'Noise_off', 'Circuit, no injected noise'; 'Noise_on', 'Circuit, noise injected'};
R = struct('name', {}, 'sndr', {}, 'pn', {}, 'ps', {}, 'P', {});
for c = 1:2
    L = dir(fullfile(din, cases{c, 1}, 'dsm8ms_s*.txt'));
    if c == 1, L = L(1); end                                                % deterministic: one run is enough
    sn = zeros(numel(L), 1);  pn = sn;  ps = sn;  P = zeros(N/2 + 1, numel(L));
    for k = 1:numel(L)
        d = readmatrix(fullfile(L(k).folder, L(k).name));
        b = 2 * (d(1:end-1, 2) > thr) - 1;                                  % drop the duplicate end point
        [sn(k), pn(k), ps(k), P(:, k)] = analyse(b(end-N+1:end), A, w, nb);
    end
    R(c) = struct('name', cases{c, 2}, 'sndr', sn, 'pn', pn, 'ps', ps, 'P', mean(P, 2));
end

% ideal model, same record, same method, 8 input phases
ph = (0:7) * pi / 4;  sn = zeros(8, 1);  pn = sn;  ps = sn;  P = zeros(N/2 + 1, 8);
for k = 1:8
    u = amp * sin(2*pi*fin*T*(0:N+3000-1) + ph(k));
    v = mod2_sim(u, s1, s2);
    [sn(k), pn(k), ps(k), P(:, k)] = analyse(v(3001:end).', A, w, nb);
end
R(3) = struct('name', 'Ideal behavioral model', 'sndr', sn, 'pn', pn, 'ps', ps, 'P', mean(P, 2));

%% Report
fprintf('%-28s %5s %10s %16s %7s %12s\n', 'case', 'runs', 'SNDR', 'min - max', 'ENOB', 'noise (V^2)');
for c = [3 1 2]
    m = 10 * log10(mean(R(c).ps) / mean(R(c).pn));                          % from the mean noise power
    fprintf('%-28s %5d %8.1f dB %7.1f - %5.1f dB %7.2f %12.3e\n', R(c).name, numel(R(c).sndr), m, ...
        min(R(c).sndr), max(R(c).sndr), (m - 1.76) / 6.02, mean(R(c).pn) * FS^2);
end
fprintf('\nper run, noise injected: %s dB\n', sprintf('%.1f  ', R(2).sndr));
fprintf('injected noise in band: %.3e V^2\n', (mean(R(2).pn) - mean(R(1).pn)) * FS^2);

%% Figure: averaged PSD (Hann), signal included
blue = [0 0.447 0.741];  grn = [0.47 0.67 0.19];  gry = [0.55 0.55 0.55];
set(0, 'DefaultAxesFontName', 'Arial', 'DefaultAxesFontSize', 12);
fig = figure('Color', 'w', 'Position', [100 100 1000 480]);
sm = @(P) smooth_hi(f, P / (fs / N), 2e4);
loglog(f(2:end), sm(R(3).P), 'Color', gry, 'LineWidth', 2.2); hold on;
loglog(f(2:end), sm(R(1).P), 'Color', blue, 'LineWidth', 1.4);
loglog(f(2:end), sm(R(2).P), 'Color', grn, 'LineWidth', 1.4);
xline(bw, ':k', '2 kHz', 'LabelVerticalAlignment', 'bottom');
grid on; box off; xlim([100 fs/2]); ylim([1e-18 1e-2]);
xlabel('Frequency (Hz)'); ylabel('PSD (FS^2/Hz)');
lg = @(c) sprintf('%s (%.1f dB)', R(c).name, 10*log10(mean(R(c).ps) / mean(R(c).pn)));
legend({lg(3), lg(1), [lg(2) ', mean of 4 runs']}, 'Location', 'northwest', 'Box', 'off');
exportgraphics(fig, fullfile(out, 'psd_8ms.png'), 'Resolution', 200);

%% Functions
function [sndr, pn, ps, P] = analyse(y, A, w, nb)
% Hann-weighted fit of the fundamental and DC, in-band noise of the residual, PSD of the whole signal.
N  = numel(y);
c  = (A .* w) \ (y .* w);
r  = (y - A * c) .* w;
Rr = abs(fft(r)).^2 / (sum(w.^2) * N) * 2;                                  % power per bin (residual)
pn = sum(Rr(2:nb+1));
ps = (c(1)^2 + c(2)^2) / 2;
sndr = 10 * log10(ps / pn);
P  = abs(fft((y - c(3)) .* w)).^2 / (sum(w.^2) * N) * 2;  P = P(1:N/2+1);    % power per bin (with the signal)
end

function v = mod2_sim(u, s1, s2)
% Ideal 2nd-order 1-bit modulator with the scaled coefficients a1 = s1, c2 = s2/s1, a2 = 2*s2.
x1 = 0;  x2 = 0;  v = zeros(size(u));
for k = 1:numel(u)
    v(k) = 2 * (x2 >= 0) - 1;
    x2 = x2 + (s2 / s1) * x1 - 2 * s2 * v(k);
    x1 = x1 + s1 * (u(k) - v(k));
end
end

function Ps = smooth_hi(f, P, fsm)
% Moving average over 15 bins above fsm only; the points below fsm are returned unchanged (index 1 = DC is dropped).
Ps = P;  i0 = find(f > fsm, 1);
Ps(i0:end) = movmean(P(i0:end), 15);
Ps = Ps(2:end);
end
