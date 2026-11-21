%% Loop gain Bode plot of OTA 1 and OTA 2 (closed-loop AC testbenches tb_FD_OTA / tb_FD_OTA_2, beta = 0.6, 25 C)
% Inputs (ngspice wrdata, wr_singlescale: f Tdb Tph), copied to ../results/ :
%   ota1_bode.txt, ota2_bode.txt
% In the testbench .control, after the .ac run:
%   let A = v(OUTp,OUTn)
%   let T = A*0.6
%   let Tdb = db(T)
%   let Tph = 180/pi*cph(T)
%   set wr_singlescale
%   option numdgt=7
%   wrdata /foss/designs/ota1_bode.txt Tdb Tph      (ota2_bode.txt for OTA 2)
% T = A * beta, Tdb in dB, Tph = continuous phase in degrees, PM = 180 + Tph at the 0 dB crossing (mod 180: the sign of the measured node can flip).
clear; clc; close all;
root = fileparts(mfilename('fullpath'));
din  = fullfile(root, '..', 'results/OTAs');
out  = fullfile(root, '..', 'docs', 'figures');
blue = [0 0.447 0.741];  gry = [0.55 0.55 0.55];
set(0, 'DefaultAxesFontName', 'Arial', 'DefaultAxesFontSize', 12);

cases = {'ota1_bode.txt', 'OTA 1', blue; 'ota2_bode.txt', 'OTA 2', gry};
beta_data = [0.6 0.6];                  % beta of the testbenches (the OTA 2 testbench still uses 0.6)
beta_use  = [0.6 33/65];                % OTA 1: 0.6; OTA 2: Ci2 / (Cs2 + Cd2 + Ci2) = 33 / (20 + 12 + 33) = 0.508, independent of the unit capacitor
req_gbw   = 17.6e6;
fig = figure('Color', 'w', 'Position', [100 100 760 640]);
tl = tiledlayout(2, 1, 'TileSpacing', 'compact', 'Padding', 'compact');
ax1 = nexttile; hold on;  ax2 = nexttile; hold on;
hh = gobjects(1, 2);  leg = cell(1, 2);
for k = 1:2
    fn = fullfile(din, cases{k, 1});
    if ~isfile(fn), fprintf('(%s not found, skipped)\n', cases{k, 1}); continue; end
    fid = fopen(fn, 'r');  d = fscanf(fid, '%f', [3 Inf]).';  fclose(fid);
    d = d(~any(isnan(d), 2), :);  f = d(:,1);  g = d(:,2);  p = d(:,3);
    if p(1) > 90, p = p - 180; end                             % align the DC phase to 0 deg
    g = g + 20*log10(beta_use(k) / beta_data(k));              % T = A*beta for the beta of the stage (the phase of A is unchanged)
    i0 = find(g(1:end-1) > 0 & g(2:end) <= 0, 1);
    a  = g(i0) / (g(i0) - g(i0+1));
    fu = 10^(log10(f(i0)) + a * (log10(f(i0+1)) - log10(f(i0))));
    pm = mod(180 + p(i0) + a * (p(i0+1) - p(i0)), 360);  if pm > 180, pm = pm - 180; end
    fprintf('%s (beta %.3f): DC loop gain %.1f dB, f_u = %.2f MHz (required beta*GBW %.1f MHz), PM = %.1f deg\n', cases{k, 2}, beta_use(k), g(1), fu / 1e6, beta_use(k)*req_gbw/1e6, pm);
    hh(k) = semilogx(ax1, f, g, 'Color', cases{k, 3}, 'LineWidth', 1.8);
    semilogx(ax2, f, p, 'Color', cases{k, 3}, 'LineWidth', 1.8);
    leg{k} = sprintf('%s, \\beta = %.3f (%.1f dB, %.1f MHz, %.1f\\circ)', cases{k, 2}, beta_use(k), g(1), fu / 1e6, pm);
end
ok = isgraphics(hh);
set(ax1, 'XScale', 'log'); set(ax2, 'XScale', 'log');
grid(ax1, 'on'); box(ax1, 'off'); grid(ax2, 'on'); box(ax2, 'off');
yline(ax1, 0, ':k');
xlim(ax1, [1e3 1e9]); xlim(ax2, [1e3 1e9]);
ylabel(ax1, 'Loop gain (dB)'); ylabel(ax2, 'Phase (deg)'); xlabel(ax2, 'Frequency (Hz)');
legend(ax1, hh(ok), leg(ok), 'Location', 'southwest', 'Box', 'off');
exportgraphics(fig, fullfile(out, 'ota_bode.png'), 'Resolution', 200);
