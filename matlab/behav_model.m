%% Behavioral model and spec derivation: 2nd-order 1-bit CIFB delta-sigma modulator
% Sections
%   1. Parameters
%   2. Behavioral simulation (effective quantizer gain, dynamic range scaling)
%   3. SQNR and noise budget
%   4. Settling -> required GBW
%   5. Finite DC gain -> required A0
%   6. Slew rate and OTA currents
%   7. Switch Ron and kT/C capacitor
% Local functions are at the end of the file (R2016b or later).
clear; clc;

%% 1. Parameters
% System
L         = 2;                   % modulator order
nbit      = 1;                   % quantizer resolution
stepSize  = 2^nbit;              % quantizer step (delta)
V_ref     = 0.6;                 % [V] reference (VREFp - VCM)
A_in      = 0.5 * V_ref;         % [V] single-ended input peak (-6 dBFS)
V_FS      = 2 * V_ref;           % [V] full scale
f_B       = 2e3;                 % [Hz] signal bandwidth
OSR       = 512;
f_s       = 2 * OSR * f_B;       % [Hz] sampling frequency (2.048 MHz)

% Dynamic range scaling coefficients (targets: max|x1| <= 1.0, max|x2| <= 1.2)
scale1    = 0.30;
scale2    = 0.18;

% Circuit assumptions
target_ENOB  = 16;
zeta         = 1/sqrt(2);        % damping factor of the 2nd-order OTA response
beta         = 0.6;              % feedback factor (integrator 1)
alloc_settle = 0.75;             % share of the half period used for linear settling
A_o          = 60;               % [dB] example OTA gain used for the leakage check

%% 2. Behavioral simulation
N      = 65536;
fin    = 37 / N;                 % coherent input frequency
n      = 0:N-1;

% 2a. Effective quantizer gain k_eff at -6 dBFS (standard MOD2: s1 = s2 = 1)
u6 = 10^(-6/20) * sin(2*pi*fin*n);
[v6, ~, x2_6] = mod2_sim(u6, 1, 1);
settle = 1000;
y = x2_6(settle:end);            % quantizer input
q = v6(settle:end);              % quantizer output (same sample)
k_eff   = (y * q') / (y * y');
sigma_y = std(y);
fprintf('--- Effective quantizer gain ---\n');
fprintf('Quantizer input std (sigma): %.4f\n', sigma_y);
fprintf('Effective gain (k)         : %.4f\n', k_eff);
fprintf('Theoretical (0.798/sigma)  : %.4f\n\n', 0.79788 / sigma_y);

% 2b. Dynamic range scaling at -3 dBFS (worst allowed input)
amp_dBFS = -3;
u3 = 10^(amp_dBFS/20) * sin(2*pi*fin*n);
[v_std, x1_std, x2_std] = mod2_sim(u3, 1, 1);               % unscaled
[v_scl, x1_scl, x2_scl] = mod2_sim(u3, scale1, scale2);     % scaled
settle_dr = 500;
x1_std = x1_std(settle_dr:end);  x2_std = x2_std(settle_dr:end);
x1_scl = x1_scl(settle_dr:end);  x2_scl = x2_scl(settle_dr:end);
fprintf('=== Dynamic range scaling (%.0f dBFS input) ===\n', amp_dBFS);
fprintf('[Standard MOD2] max|x1| = %6.2f | max|x2| = %6.2f\n', max(abs(x1_std)), max(abs(x2_std)));
fprintf('[Scaled MOD2]   max|x1| = %6.2f | max|x2| = %6.2f\n', max(abs(x1_scl)), max(abs(x2_scl)));
fprintf('Bitstream identical: %d (1 = scaling preserves the output exactly)\n\n', isequal(v_std, v_scl));

plot_swing = true;               % set false to skip the histograms
if plot_swing
    figure('Color', 'w', 'Position', [100 100 1000 500]);
    sgtitle(sprintf('Integrator output swing before / after dynamic range scaling (%.0f dBFS input)', amp_dBFS));
    subplot(2,2,1); histogram(x1_std, 50, 'FaceColor', 'r', 'FaceAlpha', 0.6);
    title('Unscaled: integrator 1 (x_1)'); grid on; xlabel('x_1 (normalized)'); ylabel('Count');
    subplot(2,2,2); histogram(x2_std, 50, 'FaceColor', 'r', 'FaceAlpha', 0.6);
    title('Unscaled: integrator 2 (x_2)'); grid on; xlabel('x_2 (normalized)'); ylabel('Count');
    subplot(2,2,3); histogram(x1_scl, 50, 'FaceColor', 'b', 'FaceAlpha', 0.7);
    title('Scaled: integrator 1 (x_1), limit \pm1.0'); grid on; xlabel('x_1 (normalized)'); ylabel('Count');
    xline([-1.0 1.0], '--k');
    subplot(2,2,4); histogram(x2_scl, 50, 'FaceColor', 'b', 'FaceAlpha', 0.7);
    title('Scaled: integrator 2 (x_2), limit \pm1.2'); grid on; xlabel('x_2 (normalized)'); ylabel('Count');
    xline([-1.2 1.2], '--k');
end

%% 3. SQNR and noise budget
P_signal      = (2*A_in)^2 / 2;                    % [V^2] differential signal power
P_signal_norm = (2*A_in/V_FS)^2 / 2;               % normalized to full scale

% In-band quantization noise (Taylor-series integration of the NTF)
IBQN        = pi^(2*L) * stepSize^2 / (12 * (2*L+1) * OSR^(2*L+1));
SQNR_ideal  = 10*log10(P_signal_norm / IBQN);
IBQN_actual = IBQN / k_eff^2;                      % include quantizer gain
SQNR_actual = 10*log10(P_signal_norm / IBQN_actual);
IBQN_V      = IBQN_actual * V_FS^2;                % [V^2]

% About 10 % of the noise budget goes to quantization noise
SNDR = SQNR_actual - 10;
ENOB = (SNDR - 1.76) / 6.02;

%% 4. Settling -> required GBW (2nd-order response)
phase_margin = atand(2*zeta / sqrt(sqrt(1 + 4*zeta^4) - 2*zeta^2));   % exact, 65.5 deg for zeta = 1/sqrt(2)
epsilon_max  = 2^-(target_ENOB + 1);               % half-LSB settling error
delta        = log(1/sqrt(1 - zeta^2));
n_tau        = log(1/epsilon_max) + delta;         % required number of time constants

T_int    = 1 / (2*f_s);                            % [s] half-clock integration window
T_settle = alloc_settle * T_int;                   % [s] linear settling time
T_slew   = T_int - T_settle;                       % [s] slewing time

GBW_Tsettle  = n_tau / (2*pi*beta);                % GBW * T_settle
GBW_required = GBW_Tsettle / T_settle;             % [Hz]

%% 5. Finite DC gain -> required A0
g1 = scale1 + scale1;                              % integrator 1: input + DAC coefficient
g2 = scale2/scale1 + 2*scale2;                     % integrator 2: input + DAC coefficient
mu_1st = g1 / 10^(A_o/20);                         % leakage at A_o (example)
mu_2nd = g2 / 10^(A_o/20);

target_SNDR    = target_ENOB*6.02 + 1.76;
target_SQNR    = target_SNDR + 10;
IBQN_realistic = P_signal_norm / 10^(target_SQNR/10);   % allowed quantization noise
delta_IBQN     = IBQN_realistic - IBQN_actual;          % allowed increase from leakage

target_mu  = sqrt(36 * k_eff^2 * delta_IBQN * OSR^3 / (pi^2 * stepSize^2));   % max (mu1 + mu2)
target_A_o = 20*log10((g1 + g2) / target_mu);                                  % [dB], spec (conservative)
A_o_exact  = 20*log10(sqrt(g1^2 + g2^2) / target_mu);                          % [dB], exact (root-sum-square)

%% 6. Slew rate and OTA currents
max_input_swing = scale1 * (A_in + V_ref);         % [V] worst-case output step of integrator 1
SR          = max_input_swing / T_slew;            % [V/s]
Marginal_SR = 1.5 * SR;                            % 50 % margin

C_ratio = 0.18;                                    % Cc / C_L
C_Leff  = 6.8e-12;                                 % [F] effective load of OTA 1
C_c     = C_Leff * C_ratio;                        % [F]

Min_Itail = SR * C_c;                              % [A] slew limit
Min_Iout  = SR * (C_c + C_Leff);                   % [A] slew limit

GBW_target = 30e6;                                 % [Hz]
gm1 = 2*pi*GBW_target * C_c;                       % [S]
gm2 = 2*beta * gm1 * C_Leff / C_c;                 % [S] wp2 = 2*beta*GBW (PM ~ 65.5 deg)

gmid1_slew = 2*gm1 / Min_Itail;                    % gm/Id implied by the slew-limited current
gmid2_slew = gm2 / Min_Iout;

target_gmid1 = 15;  target_gmid2 = 15;
Itail_uA = 2*gm1 / target_gmid1 * 1e6;             % [uA] tail current (two input devices)
Iout_uA  = gm2 / target_gmid2 * 1e6;               % [uA] output stage current

ft_2 = gm2 / (2*pi*15e-15);                        % [Hz] ft reference for sizing (Cgg = 15 fF)
gm1_over_15 = gm1 / 15;

%% 7. Switch Ron and kT/C capacitor
t_phase   = 1 / (2*f_s);                           % [s]
t_overlap = floor(t_phase * 1e8) / 1e8;            % [s] rounded down to 10 ns
N_error   = log(2) * (target_ENOB + 1);            % RC time constants for half-LSB settling

C_s     = 4.2e-12;                                 % [F] sampling cap (Cd = Cs, driven by the same switch)
Max_Ron = t_overlap / (2 * C_s * N_error);         % [ohm]

kT = 4.14e-21;                                     % [J] at 300 K
total_noise_power        = P_signal / 10^(target_SNDR/10);              % [V^2]
target_IBQN              = total_noise_power / 10;                      % 10 % for quantization noise
target_thermalNoisePower = total_noise_power - target_IBQN;             % [V^2]
Minimum_Cs        = (1 / target_thermalNoisePower) * (8*kT) / OSR;      % [F]
KT_C_Noise_Power  = (8*kT / C_s) / OSR;                                 % [V^2] with the chosen Cs

%% Summary
fprintf('=============== Summary ===============\n');
fprintf('fs = %.3f MHz, T_int = %.2f ns, T_settle = %.2f ns, T_slew = %.2f ns\n', f_s/1e6, T_int*1e9, T_settle*1e9, T_slew*1e9);
fprintf('k_eff = %.4f, SQNR ideal / actual = %.1f / %.1f dB, ENOB = %.2f\n', k_eff, SQNR_ideal, SQNR_actual, ENOB);
fprintf('PM = %.1f deg, n_tau = %.2f, GBW required = %.2f MHz\n', phase_margin, n_tau, GBW_required/1e6);
fprintf('A0 required = %.2f dB (conservative), %.2f dB (exact), mu_max = %.4f\n', target_A_o, A_o_exact, target_mu);
fprintf('SR = %.2f V/us (+50%% = %.2f V/us)\n', SR/1e6, Marginal_SR/1e6);
fprintf('Cc = %.2f pF, gm1 = %.1f uS, gm2 = %.1f uS, Itail = %.1f uA, Iout = %.1f uA\n', C_c*1e12, gm1*1e6, gm2*1e6, Itail_uA, Iout_uA);
fprintf('Max Ron = %.2f kOhm (Cs = Cd = %.1f pF), Cs,min = %.2f pF\n', Max_Ron/1e3, C_s*1e12, Minimum_Cs*1e12);

%% Local functions
function [v, x1, x2] = mod2_sim(u, s1, s2)
% Behavioral 2nd-order CIFB modulator with a 1-bit quantizer.
% s1 = s2 = 1 gives the standard MOD2, other values give the scaled version.
    N  = numel(u);
    v  = zeros(1, N);  x1 = zeros(1, N);  x2 = zeros(1, N);
    a1 = 0;  a2 = 0;
    for i = 1:N
        v(i)  = 2*(a2 >= 0) - 1;                     % 1-bit quantizer
        x1(i) = a1;  x2(i) = a2;
        a1 = a1 + s1*u(i) - s1*v(i);                 % integrator 1
        a2 = a2 + (s2/s1)*x1(i) - 2*s2*v(i);         % integrator 2
    end
end
