%% Check the PSD of the trnoise sources used for the noise injection (no circuit)
% Input: ../results/noise/trnoise_check.txt written by netlists/tb_trnoise_check.spice (wrdata: time v(n1) v(n2) ...).
%   n1 = kT/C source : trnoise(63.7u 488.28n 0 0)
%   n2 = flicker src : trnoise(0 1u 0.85 66.4u)
% The wrdata time axis is not uniform, so the data are interpolated onto a uniform grid first.
% Needs the Signal Processing Toolbox (pwelch).
clear; clc; close all;

root = fileparts(mfilename('fullpath'));
f_in = fullfile(root, '..', 'results', 'noise', 'trnoise_check.txt');
fid = fopen(f_in, 'r');  d = fscanf(fid, '%f', [4 Inf]).';  fclose(fid);   % wrdata: no header, 4 columns (t v1 t v2)
t  = d(:, 1);   v1 = d(:, 2);   v2 = d(:, 4);            % wrdata with wr_vecnames off: t v1 t v2 (check the columns)
if size(d, 2) < 4, v2 = d(:, 3); end

ok = ~(isnan(t) | isnan(v1) | isnan(v2));                 % drop NaN rows
t = t(ok);  v1 = v1(ok);  v2 = v2(ok);
[t, iu] = unique(t);  v1 = v1(iu);  v2 = v2(iu);          % interp1 needs strictly increasing, unique times
fprintf('%d samples, t = %.3g .. %.3g s, columns in file: %d\n', numel(t), t(1), t(end), size(d, 2));

dt = 0.2e-6;  fsamp = 1 / dt;
tu = (t(1) : dt : t(end)).';
x1 = interp1(t, v1, tu, 'linear');  x2 = interp1(t, v2, tu, 'linear');

% targets
NA = 63.7e-6;  NT = 488.28e-9;
S_kTC_target = 2 * NA^2 * NT;                             % one-sided PSD of one white source [V^2/Hz]
fprintf('kT/C source target PSD : %.3e V^2/Hz (one source), %.3e V^2/Hz (two sources)\n', S_kTC_target, 2*S_kTC_target);

nfft = 2^16;
[P1, f] = pwelch(x1 - mean(x1), hann(nfft), nfft/2, nfft, fsamp);
[P2, ~] = pwelch(x2 - mean(x2), hann(nfft), nfft/2, nfft, fsamp);

band = @(P, lo, hi) mean(P(f >= lo & f <= hi));
fprintf('\n--- n1 (kT/C source) ---\n');
for b = [100 1e3; 1e3 1e4; 1e4 1e5]'
    fprintf('%6.0f - %6.0f Hz : %.3e V^2/Hz (%.2f x target)\n', b(1), b(2), band(P1, b(1), b(2)), band(P1, b(1), b(2)) / S_kTC_target);
end
fprintf('\n--- n2 (flicker source) ---\n');
for b = [100 300; 300 1e3; 1e3 3e3; 3e3 1e4; 1e4 3e4]'
    fprintf('%6.0f - %6.0f Hz : %.3e V^2/Hz\n', b(1), b(2), band(P2, b(1), b(2)));
end
sel = f >= 100 & f <= 2e4;
pf  = polyfit(log10(f(sel)), log10(P2(sel)), 1);
fprintf('flicker slope : f^%.2f (alpha setting 0.85), PSD at 1 kHz = %.3e V^2/Hz\n', pf(1), 10^polyval(pf, 3));

figure('Color', 'w', 'Position', [100 100 800 460]);
loglog(f(2:end), P1(2:end), 'Color', [0.55 0.55 0.55], 'LineWidth', 1.4); hold on;
loglog(f(2:end), P2(2:end), 'Color', [0 0.447 0.741], 'LineWidth', 1.4);
yline(S_kTC_target, '--k'); grid on; box off;
xlabel('Frequency (Hz)'); ylabel('PSD (V^2/Hz)'); legend({'kT/C source', 'flicker source', 'kT/C target'}, 'Box', 'off');
