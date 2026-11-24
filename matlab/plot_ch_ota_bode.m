%% Loop gain Bode plot of the chopped 1st-stage OTA (tb_ch_OTA), chopper held in both states
% Inputs (ngspice wrdata, wr_singlescale: f Tdb Tph), copied to ../results/chopper/ :
%   ch_ota_straight.txt  (V5 dc 0)    ch_ota_cross.txt  (V5 dc 1.8)
%   ch_ota_none.txt      (optional: tb_FD_OTA without the chopper, same beta = 0.6)
% T = A * 0.6 (beta = 0.6), Tdb in dB, Tph = continuous phase in degrees. PM = 180 + Tph at the 0 dB crossing.
clear; clc; close all;
root = fileparts(mfilename('fullpath'));
din  = fullfile(root, '..', 'results', 'chopper_noc');   % fixed chopper (NOC, CH2 inside the OTA); the first design is in results/chopper
out  = fullfile(root, '..', 'docs', 'figures');
blue = [0 0.447 0.741];  dk = [0.2 0.2 0.2];  gry = [0.55 0.55 0.55];
set(0, 'DefaultAxesFontName', 'Arial', 'DefaultAxesFontSize', 12);

cases = {'ch_ota_straight.txt', 'Chopper, straight', blue,  '-';
         'ch_ota_cross.txt',    'Chopper, cross',    dk,    '--';
         'ch_ota_none.txt',     'No chopper',        gry,   '-'};
fig = figure('Color', 'w', 'Position', [100 100 760 640]);
tl = tiledlayout(2, 1, 'TileSpacing', 'compact', 'Padding', 'compact');
ax1 = nexttile; hold on;  ax2 = nexttile; hold on;
leg = cell(1, 3);  hh = gobjects(1, 3);
for k = [3 1 2]                                              % draw 'no chopper' first so the chopper curves stay visible on top
    fn = fullfile(din, cases{k, 1});
    if ~isfile(fn), fprintf('(%s not found, skipped)\n', cases{k, 1}); continue; end
    d = readmatrix(fn);  d = d(~any(isnan(d), 2), :);
    f = d(:, 1);  g = d(:, 2);  p = d(:, 3);
    if p(1) > 90, p = p - 180; end                           % measured node A has the opposite sign in the straight state: align the DC phase to 0 deg
    i0 = find(g(1:end-1) > 0 & g(2:end) <= 0, 1);            % first 0 dB crossing
    if isempty(i0), fprintf('%s: no 0 dB crossing\n', cases{k, 1}); fu = NaN; pm = NaN;
    else
        a = g(i0) / (g(i0) - g(i0+1));                         % linear interpolation on log f
        fu = 10^(log10(f(i0)) + a * (log10(f(i0+1)) - log10(f(i0))));
        ph = p(i0) + a * (p(i0+1) - p(i0));   pm = mod(180 + ph, 360);
        if pm > 180, pm = pm - 180; end            % A is measured at the OTA output: a crossed input chopper flips the sign (180 deg) of that node only
        fprintf('%-22s : f_u = %.2f MHz, PM = %.1f deg, DC loop gain %.1f dB\n', cases{k, 2}, fu / 1e6, pm, g(1));
    end
    lw = 1.8 + 1.2 * (k == 3);                               % the reference is drawn thicker so a curve on top does not hide it completely
    hh(k) = semilogx(ax1, f, g, cases{k, 4}, 'Color', cases{k, 3}, 'LineWidth', lw);
    semilogx(ax2, f, p, cases{k, 4}, 'Color', cases{k, 3}, 'LineWidth', lw);
    leg{k} = sprintf('%s (%.1f MHz, %.0f\\circ)', cases{k, 2}, fu / 1e6, pm);
end
ok = isgraphics(hh);  leg = leg(ok);  hh = hh(ok);
set(ax1, 'XScale', 'log'); set(ax2, 'XScale', 'log');
grid(ax1, 'on'); box(ax1, 'off'); grid(ax2, 'on'); box(ax2, 'off');
yline(ax1, 0, ':k');  yline(ax2, -180 + 65, ':k');
xlim(ax1, [1e3 1e9]); xlim(ax2, [1e3 1e9]);
ylabel(ax1, 'Loop gain (dB)'); ylabel(ax2, 'Phase (deg)'); xlabel(ax2, 'Frequency (Hz)');
legend(ax1, hh, leg, 'Location', 'southwest', 'Box', 'off');
exportgraphics(fig, fullfile(out, 'ch_ota_bode.png'), 'Resolution', 200);
