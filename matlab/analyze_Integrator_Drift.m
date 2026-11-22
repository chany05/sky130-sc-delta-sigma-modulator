%% 1st integrator with the chopper inside the OTA: drift / pole error / compression
% Files (wrdata, wr_singlescale): t, v(OUTp), v(OUTn)
%   new_off_pos, new_off_neg : chopper off (baseline)
%   new_on_pos,  new_on_neg  : chopper on (fs/2)
clear; clc; close all;
root = fileparts(mfilename('fullpath'));
din  = fullfile(root, '..', 'results', 'drift');
T = 488.28e-9;  ts = 0.97 * T;
nfit0 = 25;                         % fit only after the output CM has settled
sets  = {'drift_pos', 'off, +VD';  'drift_neg', 'off, -VD';
         'new_on_neg',  'on, +VD';   'new_on_neg',  'on, -VD'};
cols  = {[0.55 0.55 0.55], [0.3 0.3 0.3], [0 0.447 0.741], [0.85 0.33 0.1]};

R = struct();
for c = 1:size(sets, 1)
    fn = fullfile(din, [sets{c,1} '.txt']);
    if ~isfile(fn), fprintf('(missing: %s)\n', fn); R(c).ok = false; continue; end
    d = readmatrix(fn, 'FileType', 'text');
    d = d(~any(isnan(d), 2), :);  [t, iu] = unique(d(:,1));  d = d(iu, :);
    K  = floor(t(end) / T) - 1;  tk = ((1:K).' - 1) * T + ts;
    vp = interp1(t, d(:,2), tk);  vn = interp1(t, d(:,3), tk);
    R(c).ok = true;
    R(c).vo = vp - vn;                       % differential output
    R(c).cm = (vp + vn) / 2;                 % output CM
    R(c).s  = [NaN; diff(R(c).vo)];          % step per cycle
    R(c).K  = K;

    % fits over the settled part
    n  = (nfit0:K).';
    x  = abs(R(c).vo(n));  y = abs(R(c).s(n));
    p1 = polyfit(x, y, 1);  p2 = polyfit(x, y, 2);
    R(c).beta  = p1(1);                      % pole error per cycle (dimensionless)
    R(c).quad  = p2(1) / p2(3);              % normalized quadratic coef (1/V^2)
    R(c).res1  = rms(y - polyval(p1, x));
    R(c).res2  = rms(y - polyval(p2, x));
    a = (R(c).s(n(2:end-1)) - (R(c).s(n(1:end-2)) + R(c).s(n(3:end))) / 2) / 2;
    R(c).alt   = rms(a);                     % odd / even (fs/2) alternation
    R(c).vmax  = max(x);
end

% ---- table
fprintf('\n%-12s %10s %12s %12s %14s %10s\n', 'case', '|Vo|max', 'beta/cycle', 'quad (1/V^2)', 'resid lin/quad', 'alt rms');
for c = 1:size(sets, 1)
    if ~R(c).ok, continue; end
    fprintf('%-12s %7.0f mV %+12.3e %+12.3e %6.2f/%5.2f uV %7.2f uV\n', sets{c,1}, R(c).vmax*1e3, ...
        R(c).beta, R(c).quad, R(c).res1*1e6, R(c).res2*1e6, R(c).alt*1e6);
end

% ---- chopper contribution (on - off), per sign
if all([R.ok])
    dp = R(3).beta - R(1).beta;  dn = R(4).beta - R(2).beta;
    fprintf('\nchopper contribution to beta: +VD %+.3e, -VD %+.3e  (before the fix: about +1.8e-3)\n', dp, dn);
end

% ---- plots
figure('Color', 'w', 'Position', [100 100 1200 420]);
subplot(1,3,1); hold on; grid on;
for c = 1:size(sets, 1)
    if ~R(c).ok, continue; end
    n = (3:R(c).K).';
    plot(abs(R(c).vo(n))*1e3, abs(R(c).s(n))*1e3, '-o', 'Color', cols{c}, 'MarkerSize', 2.5);
end
xline(abs(R(find([R.ok],1)).vo(nfit0))*1e3, ':', 'fit start');
xlabel('|V_{out}| (mV)'); ylabel('|step| (mV)'); title('|step| vs |V_{out}|');
legend(sets([R.ok], 2), 'Location', 'best', 'Box', 'off');

subplot(1,3,2); hold on; grid on;
for c = 1:size(sets, 1)
    if ~R(c).ok, continue; end
    plot(3:R(c).K, R(c).s(3:end)*1e3, '-', 'Color', cols{c});
end
xlabel('Cycle'); ylabel('step (mV)'); title('Step per cycle');

subplot(1,3,3); hold on; grid on;
for c = 1:size(sets, 1)
    if ~R(c).ok, continue; end
    plot(R(c).cm*1e3, '-', 'Color', cols{c});
end
xlabel('Cycle'); ylabel('Output CM (mV)'); title('Output CM');