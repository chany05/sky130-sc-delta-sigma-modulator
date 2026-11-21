%% Switch Ron figures for the README (TG at tt over temperature, Bootstrap at ss over temperature, TG vs Bootstrap at tt)
% Reads ../results/switches/{Tg,Bs}/*.txt (ngspice wrdata files) and writes PNGs to ../docs/figures.
% Figure 1 (ron_tg_tt.png)        : TG at tt over temperature. The other corners are in the README table.
% Figure 2 (ron_bs_temp.png)      : Bootstrap (ss) over temperature.
% Figure 3 (ron_tg_vs_bs_tt.png)  : TG vs Bootstrap at tt, 27 C.
% Sizes used in the simulations: TG Wn/Wp/L = 4/14/0.35 um (tb_switch_tg.spice), Bootstrap switch 1/1 um, L = 0.15 um.
clear; clc; close all;

root = fileparts(mfilename('fullpath'));
res  = fullfile(root, '..', 'results', 'switches');
out  = fullfile(root, '..', 'docs', 'figures');
rd   = @(f) readmatrix(f, 'NumHeaderLines', 1);

T    = 488.28e-9;
tags = {'m40', '27', '85', '125'};  temps = [-40 27 85 125];
cols = [0 0.447 0.741; 0.2 0.2 0.2; 0.55 0.55 0.55; 0.75 0.75 0.75];
blue = cols(1,:);  gry = [0.55 0.55 0.55];
leg  = arrayfun(@(x) sprintf('%d \\circC', x), temps, 'UniformOutput', false);
set(0, 'DefaultAxesFontName', 'Arial', 'DefaultAxesFontSize', 12);
ylim_all = [0 1100];

%% Load
corners = {'tt', 'ss', 'ff'};
tg = struct();
for k = 1:3
    for i = 1:4
        f = rd(fullfile(res, 'Tg', ['ron_tg_' corners{k} '_' tags{i} '.txt']));
        tg.(corners{k}){i} = f(:, 1:2);                      % [vin ron]
    end
end
bs_ss = cell(1, 4);  bs_tt = cell(1, 4);
for i = 1:4
    bs_ss{i} = load_bs(fullfile(res, 'Bs', ['ron_bs_ss_' tags{i} '.txt']), T, rd);
    bs_tt{i} = load_bs(fullfile(res, 'Bs', ['ron_bs_tt_' tags{i} '.txt']), T, rd);
end

%% Figure 1: TG at tt over temperature
fig = figure('Color', 'w', 'Position', [100 100 700 460]); hold on;
for i = 1:4, plot(tg.tt{i}(:,1), tg.tt{i}(:,2), 'Color', cols(i,:), 'LineWidth', 1.8); end
grid on; box off; xlim([0 1.8]); ylim(ylim_all); xlabel('V_{in} (V)'); ylabel('R_{on} (\Omega)');
legend(leg, 'Location', 'northeast', 'Box', 'off');
exportgraphics(fig, fullfile(out, 'ron_tg_tt.png'), 'Resolution', 200);

%% Figure 3: TG vs Bootstrap at tt, 27 C
fig3 = figure('Color', 'w', 'Position', [100 100 700 460]); hold on;
plot(tg.tt{2}(:,1), tg.tt{2}(:,2), 'Color', gry,  'LineWidth', 2.0);
plot(bs_tt{2}(:,1), bs_tt{2}(:,2), 'Color', blue, 'LineWidth', 2.0);
grid on; box off; xlim([0 1.8]); ylim(ylim_all); xlabel('V_{in} (V)'); ylabel('R_{on} (\Omega)');
legend({'TG', 'Bootstrap'}, 'Location', 'northeast', 'Box', 'off');
exportgraphics(fig3, fullfile(out, 'ron_tg_vs_bs_tt.png'), 'Resolution', 200);

%% Figure 2: bootstrap over temperature (ss)
fig2 = figure('Color', 'w', 'Position', [100 100 700 460]); hold on;
for i = 1:4, plot(bs_ss{i}(:,1), bs_ss{i}(:,2), 'Color', cols(i,:), 'LineWidth', 1.8); end
grid on; box off; xlim([0 1.8]); ylim([500 1500]); xlabel('V_{in} (V)'); ylabel('R_{on} (\Omega)');
legend(leg, 'Location', 'northwest', 'Box', 'off');
exportgraphics(fig2, fullfile(out, 'ron_bs_temp.png'), 'Resolution', 200);

%% Summary (printed): TG min - max over the whole sweep, Bootstrap over 0.1 - 1.7 V
fprintf('TG Ron range (ohm), whole sweep, min - max:\n');
for i = 1:4
    fprintf('  %4d C :', temps(i));
    for k = 1:3, r = tg.(corners{k}){i}(:,2);  fprintf('  %s %.0f - %.0f', corners{k}, min(r), max(r)); end
    fprintf('\n');
end
v = tg.tt{2}(:,1);  r = tg.tt{2}(:,2);
fprintf('TG tt 27 C: minimum %.0f ohm at %.2f V, peak %.0f ohm at %.2f V\n', min(r), v(r == min(r)), max(r), v(r == max(r)));
b = bs_tt{2};  sel = b(:,1) >= 0.1 & b(:,1) <= 1.7;
fprintf('Bootstrap tt 27 C: %.0f - %.0f ohm (0.1 - 1.7 V)\n', min(b(sel,2)), max(b(sel,2)));

%% ---------------- local function ----------------
function p = load_bs(fn, T, rd)
% Bootstrap Ron vs Vin from the transient ramp: per cycle average of the settled clock-high part. Columns: time ron vgs v(n1) v(clk)
    f = rd(fn);  t = f(:,1);  ph = mod(t, T);
    msk = f(:,5) > 1.7 & ph > 0.6*T & ph < 0.98*T & t > 3*T;
    c = floor(t(msk) / T) + 1;  c = c - min(c) + 1;
    p = [accumarray(c, f(msk,4), [], @mean), accumarray(c, f(msk,2), [], @mean)];
end
