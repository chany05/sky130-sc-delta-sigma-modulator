%% Bootstrap switch Ron over corners and temperature, and the distortion that follows from the Ron curve
% Reads ../results/switches/Bs/ron_bs_<corner>_<temp>.txt (ngspice wrdata: time ron vgs v(n1) v(clk), one row per time point).
% Ron is taken in the settled part of the clock-high phase and averaged per cycle (same extraction as plot_switch_ron.m).
% Distortion estimate: the switch drives C = Cs + Cd = 8.4 pF for t = 240 ns, so the unsettled fraction of a tracked voltage is
% exp(-t / (Ron(V) C)). Its dependence on Vin (through Ron(V)) is the distortion; it is evaluated for a 0.3 V amplitude sine around 0.9 V.
clear; clc; close all;
root = fileparts(mfilename('fullpath'));
res  = fullfile(root, '..', 'results', 'switches', 'Bs');
T = 488.28e-9;  tph = 240e-9;  C = 8.4e-12;  vcm = 0.9;  amp = 0.3;  fs = 2.048e6;
corners = {'tt', 'ss', 'ff'};  tags = {'m40', '27', '85', '125'};  temps = [-40 27 85 125];
rd = @(f) readmatrix(f, 'NumHeaderLines', 1);
fprintf('Ron of the bootstrap switch, 0.1 - 1.7 V (ohm):\n');
Rw = 0;  cw = '';
for k = 1:3
    for i = 1:4
        f = rd(fullfile(res, ['ron_bs_' corners{k} '_' tags{i} '.txt']));
        t = f(:,1);  ph = mod(t, T);
        msk = f(:,5) > 1.7 & ph > 0.6*T & ph < 0.98*T & t > 3*T;
        c = floor(t(msk)/T) + 1;  c = c - min(c) + 1;
        v = accumarray(c, f(msk,4), [], @mean);  r = accumarray(c, f(msk,2), [], @mean);
        [v, iu] = unique(v);  r = r(iu);
        sel = v >= 0.1 & v <= 1.7;
        fprintf('  %s %4d C : %.0f - %.0f\n', corners{k}, temps(i), min(r(sel)), max(r(sel)));
        % distortion for a 0.9 V +- 0.3 V sine
        N = 4096;  nn = 0:N-1;  kk = 53;                                % coherent: 53 cycles in 4096 points
        x = vcm + amp * sin(2*pi*kk*nn/N);
        Rx = interp1(v, r, x, 'linear', 'extrap');
        e = x .* exp(-tph ./ (Rx * C));                                 % unsettled part of the tracked voltage
        E = abs(fft(e - mean(e))).^2;  sig = 0.5 * amp^2;
        pw = 0;  for h = 2:9, pw = pw + E(h*kk+1) * 2 / N^2; end          % harmonic power (V^2), one-sided
        fprintf('       max unsettled %.2e V (%.0f dBFS of 1.2 V), harmonics 2-9: %.0f dBc\n', max(abs(e)), 20*log10(max(abs(e))/1.2), 10*log10(max(pw, 1e-60)/sig));
        if max(r(sel)) > Rw, Rw = max(r(sel)); cw = sprintf('%s %d C', corners{k}, temps(i)); end
    end
end
fprintf('worst case Ron %.0f ohm (%s): exp(-t/(Ron C)) = %.1e\n', Rw, cw, exp(-tph/(Rw*C)));
