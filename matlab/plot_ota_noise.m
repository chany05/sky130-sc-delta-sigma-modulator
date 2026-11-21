%% Input-referred noise of OTA 1 (ngspice .noise): PSD and per-device contribution in the signal band
% Inputs : ../results/FD_OTA_noise_spec.raw  (noise spectra, binary raw: frequency ... inoise_spectrum onoise_spectrum)
%          ../results/noise/noise_contrib.txt (noise2 totals of `noise v(OUTp,OUTn) V4 dec 20 1 2k 1`, 1 Hz - 2 kHz;
%                                              inoise_total.m.<dev>.<model>[.1overf|.id|...] in V rms, input referred)
% Output : ../docs/figures/ota_noise.png (a) PSD, (b) per-device share of the in-band power
clear; clc; close all;
root = fileparts(mfilename('fullpath'));
out  = fullfile(root, '..', 'docs', 'figures');
blue = [0 0.447 0.741];  gry = [0.55 0.55 0.55];
set(0, 'DefaultAxesFontName', 'Arial', 'DefaultAxesFontSize', 12);

%% (a) PSD from the raw file
fid = fopen(fullfile(root, '..', 'results', 'FD_OTA_noise_spec.raw'), 'r');  b = fread(fid, Inf, 'uint8=>uint8').';  fclose(fid);
ib  = strfind(char(b), sprintf('Binary:\n'));  hdr = char(b(1:ib-1));
nv  = sscanf(hdr(strfind(hdr, 'No. Variables:') + 14 : end), '%d', 1);
np  = sscanf(hdr(strfind(hdr, 'No. Points:') + 11 : end), '%d', 1);
lines = strsplit(hdr, newline);
names = cell(nv, 1);
iv = find(strcmp(strtrim(lines), 'Variables:'));
for k = 1:nv, tk = strsplit(strtrim(lines{iv + k}), sprintf('\t')); names{k} = tk{2}; end
raw = reshape(typecast(b(ib + 8 : ib + 7 + 8*nv*np), 'double'), nv, np);
f   = raw(1, :).';  inz = raw(strcmp(names, 'inoise_spectrum'), :).';
S1k = interp1(log10(f), inz, 3)^2;  S1 = inz(1)^2;
fprintf('input-referred noise: %.2f uV/rtHz at 1 Hz, %.3f uV/rtHz at 1 kHz (%.3e V^2/Hz)\n', inz(1)*1e6, interp1(log10(f), inz, 3)*1e6, S1k);

%% (b) per-device contribution from noise_contrib.txt
txt = fileread(fullfile(root, '..', 'results', 'noise', 'noise_contrib.txt'));
tk  = regexp(txt, '(inoise_total(?:\.[^\s=]*)?)\s*=\s*([-+0-9.eE]+)', 'tokens');
key = cellfun(@(c) c{1}, tk, 'UniformOutput', false);  val = cellfun(@(c) str2double(c{2}), tk);
get = @(n) val(strcmp(key, ['inoise_total.m.' n]));
Ptot = val(strcmp(key, 'inoise_total'))^2;
dev = {'M3, M4 (1st-stage load)', 'xm3.msky130_fd_pr__nfet_01v8';
       'M1, M2 (input pair)',     'xm1.msky130_fd_pr__pfet_01v8_lvt';
       'M5, M6 (2nd-stage driver)', 'xm5.msky130_fd_pr__nfet_01v8';
       'M7, M8 (2nd-stage current source)', 'xm7.msky130_fd_pr__pfet_01v8'};
P = zeros(size(dev, 1), 1);
for k = 1:size(dev, 1), P(k) = 2 * get(dev{k, 2})^2; end    % two devices of each pair
fprintf('in-band input-referred noise: %.3e V^2 (%.2f uV rms)\n', Ptot, sqrt(Ptot)*1e6);
for k = 1:numel(P), fprintf('%-36s %.3e V^2 (%.3f %%)\n', dev{k, 1}, P(k), 100*P(k)/Ptot); end
fprintf('sum of the pairs: %.2f %%\n', 100*sum(P)/Ptot);

fig = figure('Color', 'w', 'Position', [100 100 1100 440]);
tl = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');
nexttile;
loglog(f, inz * 1e6, 'Color', blue, 'LineWidth', 1.8); hold on; grid on; box off;
xline(2e3, '--k'); xlim([1 1e8]);
xlabel('Frequency (Hz)'); ylabel('Input-referred noise (µV/√Hz)');
text(2.4e3, max(inz)*1e6/3, '2 kHz', 'FontSize', 11);
nexttile;
barh(flipud(100 * P / Ptot), 'FaceColor', blue, 'BarWidth', 0.6); grid on; box off;
set(gca, 'YTick', 1:size(dev, 1), 'YTickLabel', flipud(dev(:, 1)), 'XScale', 'log'); xlim([1e-3 300]);
xlabel('Share of the in-band noise power (%)');
for k = 1:numel(P), text(100*P(end+1-k)/Ptot * 1.3, k, sprintf('%.3g %%', 100*P(end+1-k)/Ptot), 'FontSize', 11, 'VerticalAlignment', 'middle'); end
exportgraphics(fig, fullfile(out, 'ota_noise.png'), 'Resolution', 200);
