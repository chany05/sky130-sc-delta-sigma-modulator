%% Analyze the testbench results (integrator 1 and switches)
% Reads ../results/integrator/*.txt and ../results/switches/*/*.txt (ngspice wrdata files).
% Needs R2019a or later (readmatrix). The wrdata time axis is not uniform, so everything is
% interpolated at the sampling instants.
clear; clc; close all;

root = fileparts(mfilename('fullpath'));
res  = fullfile(root, '..', 'results');
rd   = @(f) dedup(readmatrix(f, 'NumHeaderLines', 1));

T       = 488.28e-9;             % clock period
t_samp  = 482e-9;                % sampling point in each cycle, just before phi2e falls (about 483.2 ns)
t_bit   = 300e-9;                % DAC bits are stable here (inside phi2)
LSB     = 18.3e-6;               % [V] 16 bit, 1.2 V differential peak
n_skip  = 3;                     % cycles skipped at the start (initial transient)

integ_dir = 'integrator';        % results/integrator/1st_stage and 2nd_stage
out_dir   = fullfile(root, '..', 'docs', 'figures');
stage_dirs = {'1st_stage_fixed', '2nd_stage'};   % 1st integrator: fixed chopper (the first design is in 1st_stage)

for stage = 1:2                  % both integrators, one 2 x 3 figure each (integ1_tests.png, integ2_tests.png)
stage_txt = stage_dirs{stage};
if stage == 1
    dac_ideal = 0.3 * 1.2;   CsCi = 4.2 / 14.0;     % Cd1/Ci1 * (VREFp - VREFn), Cs1/Ci1
else
    dac_ideal = 12/33 * 1.2; CsCi = 20 / 33;        % Cd2/Ci2 * (VREFp - VREFn), Cs2/Ci2
end
fprintf('Stage %d: ideal DAC step %.4f V, ideal input gain %.4f\n\n', stage, dac_ideal, CsCi);

blue = [0 0.447 0.741];  gry = [0.55 0.55 0.55];  dk = [0.13 0.13 0.13];
set(0, 'DefaultAxesFontName', 'Arial', 'DefaultAxesFontSize', 12);
% Panel label above the axes. title() is not drawn in the exported file in R2026a prerelease.
lab = @(s) text(0.5, 1.03, s, 'Units', 'normalized', 'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'bottom', 'FontName', 'Arial', 'FontSize', 13, 'FontWeight', 'bold');

%% 1) Integrator: DAC-only test  (ideal step = Cd/Ci * (VREFp - VREFn), see stage above)
d  = rd(fullfile(res, integ_dir,stage_txt, 'integ_dac.txt'));   % time OUTp OUTn DAC DAC_b clk2
t  = d(:,1);  vo = d(:,2) - d(:,3);  cm = (d(:,2) + d(:,3)) / 2;
K  = floor(t(end) / T);  k = (0:K-1)';
vk  = interp1(t, vo, k*T + t_samp);                       % output at the end of phi2
cmk = interp1(t, cm, k*T + t_samp);
bit = double(interp1(t, d(:,4), k*T + t_bit) > 0.9) - double(interp1(t, d(:,5), k*T + t_bit) > 0.9);
stp = [NaN; diff(vk)];                                    % step produced in each cycle
ok  = k >= n_skip & bit ~= 0;
g_dac   = (bit(ok)' * stp(ok)) / (bit(ok)' * bit(ok));    % gain per DAC bit (sign included)
err_dac = (abs(g_dac) / dac_ideal - 1) * 100;
fprintf('--- DAC-only test ---\n');
fprintf('Step per DAC bit : %.5f V (ideal %.4f V), error %.3f %%\n', g_dac, dac_ideal, err_dac);
fprintf('Step spread      : %.1f uV (std over %d cycles)\n', std(stp(ok) ./ bit(ok)) * 1e6, nnz(ok));
fprintf('Output CM        : mean %.4f V, min %.4f V, max %.4f V\n\n', mean(cmk(ok)), min(cmk(ok)), max(cmk(ok)));

K_dac = K;                                                % cycles of the DAC run, also used for the DC-input plots
% One figure per integrator. Row 1: DAC-only test (output, step, settling). Row 2: DC-input test (same order).
fig = figure('Color', 'w', 'Position', [60 60 1500 780]);
tl  = tiledlayout(fig, 2, 3, 'TileSpacing', 'loose', 'Padding', 'compact');
nexttile(tl, 1); plot(t*1e6, vo, 'Color', blue, 'LineWidth', 1.4); hold on;
plot((k*T + t_samp)*1e6, vk, 'o', 'Color', dk, 'MarkerSize', 4);
grid on; box off; xlabel('Time (\mus)'); ylabel('Differential output (V)'); lab('(a) DAC-only test: output');
legend({'v_{out}', 'sampled at end of \phi_2'}, 'Location', 'southwest', 'Box', 'off');
% Steps as a line with markers: the y axis zooms on the deviation from the ideal value (bars from zero hide it).
nexttile(tl, 2); plot(k(ok), stp(ok) ./ bit(ok), 'o-', 'Color', blue, 'MarkerFaceColor', blue, 'MarkerSize', 4, 'LineWidth', 1.2); hold on;
yline(dac_ideal * sign(g_dac), '--', 'ideal', 'Color', dk);
grid on; box off; xlabel('Cycle'); ylabel('Step per DAC bit (V)'); lab(sprintf('(b) Step per DAC bit: %.4f V (%+.2f %%)', g_dac, err_dac));

%% 2) Integrator: DC input test  (ideal step = -(Cs/Ci) * VD)
VD = 20e-3;
d  = rd(fullfile(res, integ_dir,stage_txt, 'integ_in.txt'));    % time OUTp OUTn clk2
t  = d(:,1);  vo = d(:,2) - d(:,3);  cm = (d(:,2) + d(:,3)) / 2;
K  = floor(t(end) / T);  k = (0:K-1)';
vk = interp1(t, vo, k*T + t_samp);  cmk = interp1(t, cm, k*T + t_samp);
stp = [NaN; diff(vk)];  ok = k >= n_skip;
s_in = mean(stp(ok));  ideal = -CsCi * VD;
fprintf('--- DC input test (VD = %.0f mV) ---\n', VD*1e3);
fprintf('Step per cycle   : %.4f mV (ideal %.4f mV), error %.2f %%\n', s_in*1e3, ideal*1e3, (s_in/ideal - 1)*100);
fprintf('Output CM        : mean %.4f V, drift %.2f mV\n\n', mean(cmk(ok)), (max(cmk(ok)) - min(cmk(ok)))*1e3);

% The DC-input run is about twice as long as the DAC run. The plots show the same number of cycles
% as the DAC test (K_dac); the printed mean step above still uses the whole run.
okp = ok & k < K_dac;  tp = t <= K_dac*T;
nexttile(tl, 4); plot(t(tp)*1e6, vo(tp)*1e3, 'Color', blue, 'LineWidth', 1.4); hold on;
plot((k(k < K_dac)*T + t_samp)*1e6, vk(k < K_dac)*1e3, 'o', 'Color', dk, 'MarkerSize', 4);
grid on; box off; xlim([0 K_dac*T*1e6]); xlabel('Time (\mus)'); ylabel('Differential output (mV)'); lab('(d) DC-input test: output');
nexttile(tl, 5); plot(k(okp), stp(okp)*1e3, 'o-', 'Color', blue, 'MarkerFaceColor', blue, 'MarkerSize', 4, 'LineWidth', 1.2); hold on;
yline(ideal*1e3, '--', 'ideal', 'Color', dk);
grid on; box off; xlabel('Cycle'); ylabel('Step per cycle (mV)'); lab(sprintf('(e) Step per cycle: %.3f mV (%+.2f %%)', s_in*1e3, (s_in/ideal - 1)*100));

%% 3) Integrator: settling residue at the end of phi2 (fine time step runs)
names = {'integ_dac_fine.txt', 'integ_in_fine.txt'};
labels = {'DAC step', 'input step'};
t_win = 40e-9;                                            % window before the sampling point
fprintf('--- Settling residue (change during the last %.0f ns of phi2) ---\n', t_win*1e9);
ttl = {'(c) DAC-only test: settling', '(f) DC-input test: settling'};
for m = 1:2
    f  = rd(fullfile(res, integ_dir,stage_txt, names{m}));
    t  = f(:,1);  vo = f(:,2) - f(:,3);
    kk = (ceil(t(1)/T) + 1 : floor(t(end)/T) - 1)';
    r  = abs(interp1(t, vo, kk*T + t_samp) - interp1(t, vo, kk*T + t_samp - t_win));
    fprintf('%-10s : max %.2f uV, median %.2f uV  (LSB = %.1f uV, max = %.3f LSB)\n', ...
        labels{m}, max(r)*1e6, median(r)*1e6, LSB*1e6, max(r)/LSB);
    % zoom on one cycle: output relative to its final value
    kz = kk(ceil(numel(kk)/2));
    tz = linspace(kz*T + 240e-9, kz*T + 490e-9, 500);
    vz = interp1(t, vo, tz) - interp1(t, vo, kz*T + t_samp);
    nexttile(tl, 3*m); semilogy((tz - kz*T)*1e9, abs(vz) + 1e-9, 'Color', blue, 'LineWidth', 1.6); hold on;
    yline(LSB, '--', '1 LSB', 'Color', dk, 'LabelHorizontalAlignment', 'left');
    xline(t_samp*1e9, ':', 'sampling point', 'Color', gry, 'LabelVerticalAlignment', 'bottom');
    grid on; box off; xlim([240 490]); ylim([1e-8 1]);
    xlabel('Time in cycle (ns)'); ylabel('|v_{out} - v_{final}| (V)'); lab(ttl{m});
end
fprintf('\n');
% print keeps the tile titles (exportgraphics crops them in R2026a prerelease)
print(fig, fullfile(out_dir, sprintf('integ%d_tests.png', stage)), '-dpng', '-r200');

% %% 4) TG switch: Ron vs input voltage (DC sweep)
% corner_tg = 'ff';                                         % corner of the include lines in tb_switch_tg.spice
% tags  = {'m40', '27', '85', '125'};  temps = [-40 27 85 125];
% cols  = [0 0.447 0.741; 0.2 0.2 0.2; 0.55 0.55 0.55; 0.75 0.75 0.75];
% figure('Color', 'w', 'Position', [100 100 700 460]); hold on;
% fprintf('--- TG switch (%s) ---\n', corner_tg);
% ron_tg27 = [];  vin_tg27 = [];
% for i = 1:4
%     f   = rd(fullfile(res, 'switches', 'Tg', ['ron_tg_',corner_tg,'_', tags{i} ,'.txt']));
%     vin = f(:,1);  ron = f(:,2);
%     plot(vin, ron, 'Color', cols(i,:), 'LineWidth', 1.8);
%     [rmax, im] = max(ron);
%     sel = vin >= 0.6 & vin <= 1.2;
%     pf  = polyfit(vin(sel), ron(sel), 1);                  % curvature = deviation from the straight line
%     fprintf('T = %4d C : max Ron = %.1f ohm at Vin = %.2f V, variation %.1f ohm, curvature %.1f ohm (0.6-1.2 V)', ...
%                 temps(i), rmax, vin(im), max(ron(sel)) - min(ron(sel)), max(abs(ron(sel) - polyval(pf, vin(sel)))));
%     if temps(i) == 27, ron_tg27 = ron; vin_tg27 = vin; end
% end
% grid on; box off; xlabel('V_{in} (V)'); ylabel('R_{on} (\Omega)'); title(sprintf('TG switch R_{on} (%s)', corner_tg));
% legend(arrayfun(@(x) sprintf('%d \\circC', x), temps, 'UniformOutput', false), 'Location', 'best', 'Box', 'off');
% fprintf('\n');
% 
% % saveas(gcf, '../docs/figures/ron_tg.svg');
% 
% %% 5) Bootstrap switch: Ron vs input voltage (transient ramp, keep the settled part of each clk-high phase)
% corner_bs = 'ss';                                         % corner of the include lines in tb_switch_bootstrap.spice
% figure('Color', 'w', 'Position', [100 100 700 460]); hold on;
% fprintf('--- Bootstrap switch (%s) ---\n', corner_bs);
% vin_bs27 = [];  ron_bs27 = [];
% for i = 1:4
%     f  = rd(fullfile(res, 'switches', 'Bs', ['ron_bs_CORNER_' tags{i} '.txt']));   % time ron vgs v(n1) v(clk)
%     t  = f(:,1);  ph = mod(t, T);
%     msk = f(:,5) > 1.7 & ph > 0.6*T & ph < 0.98*T & t > 3*T;                         % clk high and settled
%     c   = floor(t(msk) / T) + 1;  c = c - min(c) + 1;
%     vin = accumarray(c, f(msk,4), [], @mean);
%     ron = accumarray(c, f(msk,2), [], @mean);
%     vgs = accumarray(c, f(msk,3), [], @mean);
%     plot(vin, ron, 'Color', cols(i,:), 'LineWidth', 1.8);
%     sel = vin >= 0.6 & vin <= 1.2;
%     pf  = polyfit(vin(sel), ron(sel), 1);                  % curvature = deviation from the straight line
%     fprintf('T = %4d C : Ron %.1f - %.1f ohm over 0.1-1.7 V, variation %.1f ohm, curvature %.2f ohm (0.6-1.2 V), Vgs = %.2f V', ...
%         temps(i), min(ron(vin >= 0.1 & vin <= 1.7)), max(ron(vin >= 0.1 & vin <= 1.7)), max(ron(sel)) - min(ron(sel)), ...
%         max(abs(ron(sel) - polyval(pf, vin(sel)))), mean(vgs));
%     if temps(i) == 27, vin_bs27 = vin; ron_bs27 = ron; end
% end
% grid on; box off; xlabel('V_{in} (V)'); ylabel('R_{on} (\Omega)'); title(sprintf('Bootstrap switch R_{on} (%s)', corner_bs));
% legend(arrayfun(@(x) sprintf('%d \\circC', x), temps, 'UniformOutput', false), 'Location', 'best', 'Box', 'off');
% fprintf('\n');
% % saveas(gcf, '../docs/figures/ron_bootstrap.svg');
% 
% %% 6) TG vs Bootstrap at 27 C (tracking linearity)
% figure('Color', 'w', 'Position', [100 100 700 460]);
% plot(vin_tg27, ron_tg27, 'Color', gry, 'LineWidth', 2.0); hold on;
% plot(vin_bs27, ron_bs27, 'Color', blue, 'LineWidth', 2.0);
% grid on; box off; xlabel('V_{in} (V)'); ylabel('R_{on} (\Omega)'); title('R_{on} at 27 \circC');
% legend({sprintf('TG (%s)', corner_tg), sprintf('Bootstrap (%s)', corner_bs)}, 'Location', 'best', 'Box', 'off');
% % saveas(gcf, '../docs/figures/ron_compare.svg');

%% 7) Output common mode convergence (long DAC-only run, ~200 cycles)
d  = rd(fullfile(res, integ_dir,stage_txt, 'integ_dac_long.txt'));   % time OUTp OUTn
t  = d(:,1);  cm = (d(:,2) + d(:,3)) / 2;  vo = d(:,2) - d(:,3);
K  = floor(t(end) / T);  k = (0:K-1)';
cmk = interp1(t, cm, k*T + t_samp);                           % CM at the end of phi2 of every cycle
cm_inf = mean(cmk(end-19:end));                               % steady value (last 20 cycles)
err    = abs(cmk - cm_inf);
k_1mV  = find(err > 1e-3, 1, 'last') + 1;                     % cycle after which |CM - CM_inf| < 1 mV
fprintf('--- Output common mode (DAC-only, %d cycles) ---\n', K);
fprintf('Steady CM = %.4f V (target 0.9 V, offset %+.1f mV), last-20-cycle ripple %.2f mV\n', ...
    cm_inf, (cm_inf - 0.9)*1e3, (max(cmk(end-19:end)) - min(cmk(end-19:end)))*1e3);
fprintf('Settles within 1 mV after %d cycles (%.1f us)\n\n', k_1mV, k_1mV*T*1e6);

figure('Color', 'w', 'Position', [100 100 1000 430]);
tiledlayout(1, 2, 'TileSpacing', 'compact');
nexttile; plot(k*T*1e6, cmk, 'o-', 'Color', blue, 'LineWidth', 1.6, 'MarkerSize', 3); hold on;
yline(0.9, '--', 'target 0.9 V', 'Color', dk, 'LabelHorizontalAlignment', 'left');
yline(cm_inf, ':', sprintf('steady %.3f V', cm_inf), 'Color', blue, 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'bottom');
grid on; box off; xlabel('Time (\mus)'); ylabel('Output common mode (V)'); title('CM at the end of \phi_2');
nexttile; semilogy(k*T*1e6, err + 1e-6, 'Color', blue, 'LineWidth', 1.6); hold on;
yline(1e-3, '--', '1 mV', 'Color', dk, 'LabelHorizontalAlignment', 'right');
grid on; box off; xlabel('Time (\mus)'); ylabel('|CM - CM_{steady}| (V)'); title('CM convergence'); xlim([0 40]);
% saveas(gcf, '../docs/figures/integrator_cm.svg');
end   % for stage

function d = dedup(d)
d = d(~any(isnan(d), 2), :);                % 빈 줄/NaN 제거
[~, i] = unique(d(:,1), 'stable');          % 같은 시간값은 첫 번째만 남김
d = d(i, :);
end