%% Chopper error of the 1st integrator: timing / mech / NOC test sets
% 'noc' : tb with non-overlapping chopper clock + 4-phase TG chopper (files chop_<case>, no extension)
% DC differential input VD = 20 mV, DAC off: ideal step per cycle = -(Cs/Ci)*VD = -6.0 mV.
% Step per cycle is taken from the output at the end of phi2 (0.97 T), then
%   mean step          : mean of the steps of cycles 3 .. end
%   alternation (rms)  : rms of the odd / even part a_n (meaningful for fs/2)
%   |alt| / |Vout|     : mean |a_n / Vout_n|
%   dev vs off (max)   : max |s_n - s_n(off)|, chopper-only error (works for any chopper rate)
%   alpha / cycle      : mean of -(s_n - s_n(off)) / Vout_n, common (leak) part per cycle
%   A_eq               : 1/alpha in dB, equivalent integrator DC gain from the chopper leak
clear; clc; close all;
root = fileparts(mfilename('fullpath'));
T = 488.28e-9;  ts = 0.97 * T;  ideal = -6.0e-3;
which_set = 'noc';   % 'timing' | 'mech' | 'noc'

switch which_set
    case 'timing'
        din = fullfile(root, '..', 'results', 'chopper');  pre = 'chop_';  ext = '.txt';
        cases = {'base',  'chopper fs/2, reversal at 120 ns (as in the modulator)';
                 'off',   'chopper clock held low';
                 'fs4',   'chopper fs/4';
                 'fs8',   'chopper fs/8';
                 'early', 'fs/2, reversal at 30 ns';
                 'late',  'fs/2, reversal at 200 ns'};
    case 'mech'
        din = fullfile(root, '..', 'results', 'chopper');  pre = 'chopm_';  ext = '.txt';
        cases = {'base',      'both choppers TG 4/14';
                 'ideal',     'both choppers ideal switches';
                 'in_ideal',  'input chopper ideal, output TG';
                 'out_ideal', 'input TG, output chopper ideal';
                 'in_w2',     'input chopper TG 2/7 (1/2 width)';
                 'in_w1',     'input chopper TG 1/3.5 (1/4 width)'};
    case 'noc'
        din = fullfile(root, '..', 'results', 'drift');  pre = 'new_on_';  ext = '';
        cases = {'neg',  'chopper static (reference)'};
end

% ---- read all cases first (the off case is the reference for dev / alpha)
S = struct();
for c = 1:size(cases, 1)
    fn = fullfile(din, [pre cases{c, 1} ext]);
    if ~isfile(fn) && isfile([fn '.txt']), fn = [fn '.txt']; end   % accept either name
    if ~isfile(fn), fprintf('(%s not found)\n', fn); continue; end
    fid = fopen(fn, 'r');  d = fscanf(fid, '%f', [3 Inf]).';  fclose(fid);
    d = d(~any(isnan(d), 2), :);  [t, iu] = unique(d(:,1));  vo = d(iu,2) - d(iu,3);
    K = floor(t(end) / T) - 1;  k = (1:K).';
    v = interp1(t, vo, (k - 1) * T + ts);
    S.(cases{c, 1}) = struct('v', v, 's', [NaN; diff(v)], 'K', K);
end
hasOff = isfield(S, 'off');

% ---- metrics and plot
blue = [0 0.447 0.741];  gry = [0.55 0.55 0.55];  dk = [0.2 0.2 0.2];
set(0, 'DefaultAxesFontName', 'Arial', 'DefaultAxesFontSize', 12);
fig = figure('Color', 'w', 'Position', [100 100 1000 560]); hold on;
cols = {gry, blue, [0.85 0.33 0.1], [0.93 0.69 0.13], [0.47 0.67 0.19], dk, [0.64 0.08 0.18]};
fprintf('%-6s %-38s %11s %10s %9s %11s %12s %9s\n', 'case', 'description', 'mean step', 'alt rms', ...
        '|alt|/|V|', 'max dev', 'alpha/cyc', 'A_eq');
leg = {};
for c = 1:size(cases, 1)
    nm = cases{c, 1};
    if ~isfield(S, nm), continue; end
    v = S.(nm).v;  s = S.(nm).s;  K = S.(nm).K;
    n = (10 : K - 1).';
    a = (s(n) - (s(n-1) + s(n+1)) / 2) / 2;               % odd / even part

    if hasOff && ~strcmp(nm, 'off')
        Kc  = min(K, S.off.K);  m = (10 : Kc).';
        dev = s(m) - S.off.s(m);                         % chopper-only error per cycle
        alpha = -mean(dev ./ v(m));                      % magnitude loss ratio per cycle
        maxdev = max(abs(dev)) * 1e3;
        Aeq = 20 * log10(1 / abs(alpha));
        fprintf('%-6s %-38s %8.2f mV %7.2f mV %8.2f %% %8.2f mV %11.4f %% %6.1f dB\n', nm, cases{c, 2}, ...
            mean(s(3:end)) * 1e3, sqrt(mean(a.^2)) * 1e3, 100 * mean(abs(a) ./ abs(v(n))), ...
            maxdev, 100 * alpha, Aeq);
    else
        fprintf('%-6s %-38s %8.2f mV %7.2f mV %8.2f %% %11s %12s %9s\n', nm, cases{c, 2}, ...
            mean(s(3:end)) * 1e3, sqrt(mean(a.^2)) * 1e3, 100 * mean(abs(a) ./ abs(v(n))), '-', '-', '-');
    end
    plot(3:K, s(3:end) * 1e3, '-o', 'Color', cols{c}, 'LineWidth', 1.4, 'MarkerSize', 3);
    leg{end+1} = nm; %#ok<SAGROW>
end
yline(ideal * 1e3, '--', 'ideal', 'Color', dk);
grid on; box off; xlabel('Cycle'); ylabel('Step per cycle (mV)');
legend(leg, 'Location', 'southwest', 'Box', 'off');
% exportgraphics(fig, fullfile(root, '..', 'docs', 'figures', ['chopper_' which_set '.png']), 'Resolution', 150);