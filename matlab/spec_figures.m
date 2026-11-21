%% Spec figures for the README (run section by section)
% Gray + one accent color (blue), white background.
set(0, 'DefaultAxesFontName', 'Arial', 'DefaultAxesFontSize', 12, ...
       'DefaultTextFontName', 'Arial');
blue = [0 0.447 0.741];
gry  = [0.55 0.55 0.55];
lgt  = [0.74 0.74 0.74];
dk   = [0.13 0.13 0.13];

%% 1) Integrator swing before / after scaling  (scaling_histograms)
N   = 65536;                             % same record and input frequency as behav_model.m
amp = -3;                               % [dBFS] worst allowed input
u   = 10^(amp/20) * sin(2*pi*(37/N)*(0:N-1));
s1  = 0.30;  s2 = 0.18;
x1s = zeros(1,N); x2s = zeros(1,N); x1c = zeros(1,N); x2c = zeros(1,N);
a1 = 0; a2 = 0; b1 = 0; b2 = 0;
for i = 1:N
    v = 2*(a2 >= 0) - 1;                % standard MOD2
    x1s(i) = a1; x2s(i) = a2;
    a1 = a1 + u(i) - v;
    a2 = a2 + x1s(i) - 2*v;
    w = 2*(b2 >= 0) - 1;                % scaled MOD2
    x1c(i) = b1; x2c(i) = b2;
    b1 = b1 + s1*u(i) - s1*w;
    b2 = b2 + (s2/s1)*x1c(i) - 2*s2*w;
end
settle = 500;
x1s = x1s(settle:end); x2s = x2s(settle:end);
x1c = x1c(settle:end); x2c = x2c(settle:end);

figure('Color', 'w', 'Position', [100 100 1100 640]);
tl = tiledlayout(2, 2, 'TileSpacing', 'loose', 'Padding', 'loose');
% (the title is in the SVG card of the README)
ttl = @(ax, t) text(ax, 0.5, 1.04, t, 'Units', 'normalized', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 12, 'Clipping', 'off');   % title() is not drawn in -batch mode
ax = nexttile; histogram(x1s, 50, 'FaceColor', lgt, 'EdgeColor', 'w');
ttl(ax, 'Unscaled: integrator 1 output (x_1)'); xlabel('x (normalized to V_{ref})'); ylabel('Count'); box off;
ax = nexttile; histogram(x2s, 50, 'FaceColor', lgt, 'EdgeColor', 'w');
ttl(ax, 'Unscaled: integrator 2 output (x_2)'); xlabel('x (normalized to V_{ref})'); ylabel('Count'); box off;
ax = nexttile; histogram(x1c, 50, 'FaceColor', blue, 'EdgeColor', 'w');
xline([-1 1], '--', 'Color', dk, 'LineWidth', 1.4); xlim([-1.2 1.2]);
ttl(ax, 'Scaled: integrator 1 output (x_1), limit \pm1.0'); xlabel('x (normalized to V_{ref})'); ylabel('Count'); box off;
ax = nexttile; histogram(x2c, 50, 'FaceColor', blue, 'EdgeColor', 'w');
xline([-1.2 1.2], '--', 'Color', dk, 'LineWidth', 1.4); xlim([-1.4 1.4]);
ttl(ax, 'Scaled: integrator 2 output (x_2), limit \pm1.2'); xlabel('x (normalized to V_{ref})'); ylabel('Count'); box off;
fprintf('max|x| unscaled %.2f / %.2f, scaled %.2f / %.2f\n', ...
    max(abs(x1s)), max(abs(x2s)), max(abs(x1c)), max(abs(x2c)));
exportgraphics(gcf, fullfile(fileparts(mfilename('fullpath')), '..', 'docs', 'figures', 'scaling_histograms.png'), 'Resolution', 150, 'Padding', 14);

%% 2) Settling error vs time  (settling_error)
beta    = 0.6;                          % feedback factor (integrator 1)
zeta    = 1/sqrt(2);                    % PM ~ 65.5 deg
eps_max = 2^-17;                        % half LSB at 16 bit
Tsettle = 183.1e-9;                     % [s] linear settling time
n_tau   = log(1/eps_max) + log(1/sqrt(1-zeta^2));
GBW_req = n_tau / (2*pi*beta*Tsettle);  % [Hz] ~ 17.6 MHz
GBW_des = 30e6;                         % [Hz] design target

t   = linspace(0, 250e-9, 2001);
env = @(gbw) exp(-2*pi*beta*gbw*t) / sqrt(1 - zeta^2);   % error envelope
x   = 2*pi*beta*GBW_req*t;
ex  = abs(exp(-x) .* (cos(x) + sin(x)));                 % exact error (zeta = 1/sqrt2)

figure('Color', 'w', 'Position', [100 100 900 500]);
semilogy(t*1e9, max(ex, 1e-9), 'Color', [0.62 0.78 0.88], 'LineWidth', 1.2); hold on;
semilogy(t*1e9, env(GBW_req), 'Color', blue, 'LineWidth', 2.6);
semilogy(t*1e9, env(GBW_des), '--', 'Color', gry, 'LineWidth', 2.2);
yline(eps_max, '--', '\epsilon_{max} = 2^{-17} (half LSB, 16 bit)', 'Color', dk, ...
    'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'top');
xline(Tsettle*1e9, '--', 'T_{settle} = 183 ns', 'Color', dk, 'LabelVerticalAlignment', 'top');
plot(Tsettle*1e9, eps_max, 'o', 'MarkerFaceColor', blue, 'MarkerEdgeColor', blue);
ylim([1e-8 1.5]); xlim([0 250]); grid on; box off; set(gca, 'GridAlpha', 0.15);
xlabel('Time (ns)'); ylabel('Settling error');
title('2nd-order settling error vs time');
legend({sprintf('GBW = %.1f MHz, exact |error|', GBW_req/1e6), ...
        sprintf('GBW = %.1f MHz (required), envelope', GBW_req/1e6), ...
        'GBW = 30 MHz (design target), envelope'}, 'Location', 'southwest', 'Box', 'off');
% saveas(gcf, 'settling_error.svg');

%% 3) OTA gain vs SQNR and leakage budget  (gain_vs_sqnr)
OSR  = 512;  k = 0.628;  stepSize = 2;  Psig = 0.125;      % Psig: -6 dBFS, normalized
g1 = 0.6;  g2 = 0.96;                                      % g1 = s1 + s1, g2 = s2/s1 + 2*s2
IBQN     = pi^4 * stepSize^2 / (12 * 5 * OSR^5);
IBQN_act = IBQN / k^2;
dI = @(mu) stepSize^2 / (12*k^2) * pi^2 * mu.^2 / (3*OSR^3);

target_SQNR = 16*6.02 + 1.76 + 10;                         % SNDR + 10 dB (10 % Q-noise budget)
dIBQN_max   = Psig / 10^(target_SQNR/10) - IBQN_act;
mu_max      = sqrt(36 * k^2 * OSR^3 * dIBQN_max / (pi^2 * stepSize^2));
A0_spec_dB  = 20*log10((g1 + g2) / mu_max);                % ~ 45.3 dB

A0dB = 30:0.25:70;  A0 = 10.^(A0dB/20);
sqnr_sum = 10*log10(Psig ./ (IBQN_act + dI((g1 + g2) ./ A0)));          % conservative model used for the spec

figure('Color', 'w', 'Position', [100 100 1000 470]);
tiledlayout(1, 4, 'TileSpacing', 'loose', 'Padding', 'compact');
nexttile([1 3]);
plot(A0dB, sqnr_sum, 'Color', blue, 'LineWidth', 2.8); hold on;
yline(target_SQNR, '--', sprintf('Target SQNR = %.1f dB (SNDR + 10 dB)', target_SQNR), 'Color', dk, ...
    'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'bottom');
yline(10*log10(Psig/IBQN_act), ':', sprintf('No leakage: %.1f dB', 10*log10(Psig/IBQN_act)), 'Color', gry, ...
    'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'bottom', 'LineWidth', 1.2);
xline(A0_spec_dB, '--', sprintf('A0 = %.1f dB', A0_spec_dB), 'Color', blue, 'LabelVerticalAlignment', 'bottom');
plot(A0_spec_dB, target_SQNR, 'o', 'MarkerFaceColor', blue, 'MarkerEdgeColor', blue);
xlim([30 70]); ylim([84 118]); grid on; box off; set(gca, 'GridAlpha', 0.15);
xlabel('OTA DC gain A0 (dB)'); ylabel('SQNR (dB)'); title('SQNR vs OTA DC gain (\mu_1 + \mu_2 model)');

nexttile;
A0s = 10^(A0_spec_dB/20);
mu1 = g1/A0s*1e3;  mu2 = g2/A0s*1e3;
bb = bar(1, [mu1 mu2], 0.8, 'stacked', 'EdgeColor', 'w'); hold on;
bb(1).FaceColor = blue; bb(2).FaceColor = lgt;
yline(mu_max*1e3, '--', sprintf('\\mu_{max} = %.1f', mu_max*1e3), 'Color', dk, 'LabelHorizontalAlignment', 'right');
text(1, mu1/2, sprintf('\\mu_1 = %.1f', mu1), 'Color', 'w', 'HorizontalAlignment', 'center');
text(1, mu1 + mu2/2, sprintf('\\mu_2 = %.1f', mu2), 'HorizontalAlignment', 'center');
set(gca, 'XTick', 1, 'XTickLabel', {sprintf('A0 = %.1f dB', A0_spec_dB)}, 'Box', 'off');
xlim([0.4 1.6]); ylim([0 10]); ylabel('Leakage \mu (\times10^{-3})'); title('Leakage budget');
fprintf('mu_max = %.4f, A0 spec = %.2f dB\n', mu_max, A0_spec_dB);
% saveas(gcf, 'gain_vs_sqnr.svg');
