%% Chopper standalone: switching spike and modulation (netlists/tb_fixed_chopper_standalone.spice)
% Inputs (copy from /foss/designs): ../results/chopper/chopper_spike.txt  (t vout OUT1 OUT2 clkCh clkCh_b)
%                                   ../results/chopper/chopper_mod.txt    (t vout vin)
clear; clc; close all;
root = fileparts(mfilename('fullpath'));
dir_in = fullfile(root, '..', 'results', 'chopper_noc');   % fixed chopper (NOC, CH2 inside the OTA); the first design is in results/chopper
Tch = 976.56e-9;  fch = 1 / Tch;  fin = 20e3;

%% 1) spike with zero input (differential output)
d = readmatrix(fullfile(dir_in, 'chopper_spike.txt'));
d = d(~any(isnan(d), 2), :);
[t, iu] = unique(d(:,1));  vo = d(iu,2);  clk = d(iu,5);    % wr_singlescale: t vout OUT1 OUT2 clkCh clkCh_b
ok = t > 3 * Tch;                                           % skip the start-up
t = t(ok);  vo = vo(ok);  clk = clk(ok);
vo = vo - median(vo);
[vpk, ipk] = max(abs(vo));
o1 = d(iu,3);  o1 = o1(ok);  o1 = o1 - 0.9;                 % single-ended OUT1 relative to the 0.9 V input common mode
fprintf('Spike (zero input, 5 %% load mismatch): differential peak |vout| = %.3g mV, single-ended OUT1 peak = %.3g mV\n', ...
    vpk * 1e3, max(abs(o1)) * 1e3);
tol = 50e-6;                                                % settling band 50 uV (about 1/2 LSB of 16 bit = 9 uV is stricter; change as needed)
edges = t(find(diff(clk > 0.9) ~= 0) + 1);                  % clock edges of the chopper
ts = zeros(size(edges));
for k = 1:numel(edges)-1
    m = t >= edges(k) - 10e-9 & t < edges(k+1) - 10e-9;      % clkCh_b switches a little before clkCh (nand delay): start 10 ns early
    tt = t(m);  vv = abs(o1(m) - o1(find(m, 1, 'last')));   % single-ended OUT1: deviation from its settled value at the end of the half period
    first = find(vv > tol, 1, 'first');  last = find(vv > tol, 1, 'last');
    if isempty(first), ts(k) = 0; else, ts(k) = tt(last) - tt(first); end   % from the start of the spike to the last time above tol
end
fprintf('Recovery time to %.0f uV after each chopper edge: max %.1f ns, typical %.1f ns (half period %.0f ns)\n', ...
    tol * 1e6, max(ts) * 1e9, median(ts(ts > 0)) * 1e9, Tch / 2 * 1e9);
set(0, 'DefaultAxesFontName', 'Arial', 'DefaultAxesFontSize', 12);
fig = figure('Color','w','Position',[100 100 1100 420]);
tl = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');
nexttile;
plot((t - edges(1)) * 1e9, vo * 1e3, 'Color', [0 0.447 0.741], 'LineWidth', 1.6); grid on; box off;
xlim([0.49*Tch*1e9 0.51*Tch*1e9]); xlabel('Time (ns)'); ylabel('Differential output (mV)');
title('(a) Switching spike, zero input, 5 % mismatch', 'FontWeight', 'bold');

%% 2) modulation of the sine
d = readmatrix(fullfile(dir_in, 'chopper_mod.txt'));
d = d(~any(isnan(d), 2), :);
[t, iu] = unique(d(:,1));  vo = d(iu,2);  vi = d(iu,3);     % wr_singlescale: t vout vin
dt = 1e-9;  tu = (t(1):dt:t(end)).';  fsamp = 1/dt;
x = interp1(t, vo, tu);  y = interp1(t, vi, tu);
msk = tu > 10e-6;  x = x(msk);  y = y(msk);
n = 2^floor(log2(numel(x)));  x = x(1:n);  y = y(1:n);
w = blackmanharris(n);  f = (0:n/2).' * fsamp / n;
X = abs(fft(x .* w)).^2;  X = X(1:n/2+1);  Y = abs(fft(y .* w)).^2;  Y = Y(1:n/2+1);
pk = @(P, f0) sqrt(sum(P(abs(f - f0) < 3.5 * fsamp / n)));  % amplitude-like sum around f0 (+-3 bins: the two sidebands are 2*fin = 40 kHz = 5 bins apart)
a_in  = pk(Y, fin);
a_mod = pk(X, fch - fin) ;   a_mod2 = pk(X, fch + fin);
a_leak = pk(X, fin);                                         % input frequency leaking straight through
fprintf('\nModulation: input %.3g V (amp units); at fch-fin %.3g, fch+fin %.3g (relative %.2f / %.2f), leak at fin %.1f dB below the modulated tone\n', ...
    a_in, a_mod, a_mod2, a_mod / a_in, a_mod2 / a_in, 20*log10(a_leak / max(a_mod, a_mod2)));
nexttile;
semilogy(f / 1e6, X, 'Color', [0 0.447 0.741], 'LineWidth', 1.4); grid on; box off; xlim([0 2.5]);
xlabel('Frequency (MHz)'); ylabel('Power (a.u.)'); title('(b) Output spectrum, 20 kHz input', 'FontWeight', 'bold');
exportgraphics(fig, fullfile(root, '..', 'docs', 'figures', 'chopper_spike_spectrum.png'), 'Resolution', 200);
