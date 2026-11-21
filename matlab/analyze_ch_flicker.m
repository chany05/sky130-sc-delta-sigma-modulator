%% Flicker noise rejection of the chopper (netlists/tb_ch_ota_flicker.spice)
% Inputs (copy from /foss/designs to ../results/chopper/): ch_flk_on.txt (chopper on + flicker), ch_flk_off.txt (chopper off + flicker),
%                                                         ch_flk_floor.txt (chopper on, no flicker: numerical floor).
% Each file: t, differential output after the 2nd chopper (wrdata, 100 ns grid with 'interp').
% The modulated flicker (around f_ch = 1.024 MHz) and the chopper spikes are removed by a sinc^3 decimation (x100, 10 MHz -> 100 kHz),
% then the baseband PSD is estimated with Welch. The gain from the OTA input to this output is the same in the three runs, so the ratio of the
% in-band output PSD (chopper off / chopper on) is the improvement of the input-referred flicker noise. Case 3 shows the numerical floor.
clear; clc; close all;
root = fileparts(mfilename('fullpath'));
din  = fullfile(root, '..', 'results', 'chopper');
files = {'ch_flk_off.txt', 'ch_flk_on.txt', 'ch_flk_floor.txt'};
lab   = {'Chopper off', 'Chopper on', 'Chopper on, no flicker (floor)'};
col   = {[0.55 0.55 0.55], [0 0.447 0.741], [0.2 0.2 0.2]};
set(0, 'DefaultAxesFontName', 'Arial', 'DefaultAxesFontSize', 12);
M = 100;  fs1 = 10e6;  fs2 = fs1 / M;  tskip = 1e-3;
bands = [200 500; 500 1000; 1000 2000; 200 2000];
P = cell(1, 3);  fq = [];
fig = figure('Color', 'w', 'Position', [100 100 800 480]);
for k = 1:3
    fn = fullfile(din, files{k});
    if ~isfile(fn), fprintf('(%s not found)\n', files{k}); continue; end
    fid = fopen(fn, 'r');  d = fscanf(fid, '%f', [2 Inf]).';  fclose(fid);
    d = d(~any(isnan(d), 2), :);  [t, iu] = unique(d(:,1));  v = d(iu, 2);
    tu = (t(1) : 1/fs1 : t(end)).';  x = interp1(t, v, tu);  x = x(tu >= tskip);  x = x - mean(x);
    for i = 1:3, c = [0; cumsum(x)]; x = (c(M+1:end) - c(1:end-M)) / M; end   % sinc^3 moving average
    x = x(1:M:end);
    nfft = 2^floor(log2(numel(x) / 4));
    [p, f] = pwelch(x, hann(nfft), nfft/2, nfft, fs2);
    P{k} = p;  fq = f;
    loglog(f(2:end), p(2:end), 'Color', col{k}, 'LineWidth', 1.6); hold on;
    fprintf('%-32s: %.1f ms used, df = %.0f Hz', lab{k}, numel(x) / fs2 * 1e3, fs2 / nfft);
    for b = 1:size(bands, 1), m = fq >= bands(b,1) & fq < bands(b,2); fprintf(' | %d-%d Hz: %.2e', bands(b,1), bands(b,2), mean(p(m))); end
    fprintf(' V^2/Hz\n');
end
grid on; box off; xlim([100 3e3]); xlabel('Frequency (Hz)'); ylabel('Output PSD (V^2/Hz)');
legend(lab, 'Location', 'southwest', 'Box', 'off');
if ~isempty(P{1}) && ~isempty(P{2})
    for b = 1:size(bands, 1)
        m = fq >= bands(b,1) & fq < bands(b,2);
        r = mean(P{1}(m)) / mean(P{2}(m));
        fprintf('improvement %4d-%4d Hz: %.1f x (%.1f dB)', bands(b,1), bands(b,2), r, 10*log10(r));
        if ~isempty(P{3}), fprintf('   [floor / chopper on: %.2f]', mean(P{3}(m)) / mean(P{2}(m))); end
        fprintf('\n');
    end
    fprintf('(if the floor is comparable to the chopper-on PSD, the improvement is only a lower bound)\n');
end
% exportgraphics(fig, fullfile(root, '..', 'docs', 'figures', 'ch_flicker_psd.png'), 'Resolution', 200);
