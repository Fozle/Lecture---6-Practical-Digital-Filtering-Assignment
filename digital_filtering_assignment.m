
%% DIGITAL FILTERING ASSIGNMENT
% Part A: Sensor Signal Filtering (FIR and IIR)
% Part B: 50 Hz Hum Removal from Audio
%
% Student: Fozle Arafat Chowdhury
% All figures are saved automatically.
%
% Required: Signal Processing Toolbox

clear;
close all;
clc;

fprintf('========================================\n');
fprintf('DIGITAL FILTERING ASSIGNMENT\n');
fprintf('========================================\n');

%% 1. MATLAB VERSION AND TOOLBOX

fprintf('\n--- SOFTWARE INFORMATION ---\n');

fprintf('MATLAB Version: %s\n',version);

toolboxInfo = ver('signal');

if isempty(toolboxInfo)
    error('Signal Processing Toolbox is not available.');
else
    fprintf('Toolbox: %s\n',toolboxInfo.Name);
    fprintf('Toolbox Version: %s\n',toolboxInfo.Version);
end

%% ========================================================
% PART A: SENSOR SIGNAL FILTERING
% =========================================================

fprintf('\n--- PART A: SENSOR FILTERING ---\n');

%% 2. GENERATE SENSOR SIGNAL

Fs = 1000;

t = (0:1/Fs:2-1/Fs)';

rng(7);

% Clean wanted signal
clean = sin(2*pi*5*t) + ...
        0.35*sin(2*pi*12*t);

% Interference and random noise
noise = 0.35*sin(2*pi*50*t) + ...
        0.20*sin(2*pi*137*t) + ...
        0.25*randn(size(t));

% Noisy signal
x = clean + noise;

%% 3. DESIGN FIR AND IIR FILTERS

fc = 20;

% FIR low-pass filter
% Order = 60, taps = 61
bFIR = fir1(60,fc/(Fs/2),'low');

% Fourth-order Butterworth IIR
[bIIR,aIIR] = butter(4,fc/(Fs/2),'low');

%% 4. APPLY FILTERS

% Zero-phase offline filtering
yFIR = filtfilt(bFIR,1,x);

yIIR = filtfilt(bIIR,aIIR,x);

%% 5. CALCULATE RMSE

rmseNoisy = sqrt(mean((x-clean).^2));

rmseFIR = sqrt(mean((yFIR-clean).^2));

rmseIIR = sqrt(mean((yIIR-clean).^2));

fprintf('\n--- SENSOR RMSE RESULTS ---\n');

fprintf('Noisy signal: %.6f\n',rmseNoisy);

fprintf('FIR output: %.6f\n',rmseFIR);

fprintf('IIR output: %.6f\n',rmseIIR);

RMSE_Table = table( ...
    ["Noisy input";"FIR output";"IIR output"], ...
    [rmseNoisy;rmseFIR;rmseIIR], ...
    'VariableNames',{'Signal','RMSE'});

disp(RMSE_Table);

%% 6. FIGURE 1: SENSOR TIME COMPARISON

figure('Name','Sensor Time Comparison','Color','w');

idx = t <= 0.2;

plot(t(idx),clean(idx),'k','LineWidth',1.5);
hold on;

plot(t(idx),x(idx),'Color',[0.7 0.7 0.7]);

plot(t(idx),yFIR(idx),'b','LineWidth',1.2);

plot(t(idx),yIIR(idx),'r','LineWidth',1.2);

grid on;

xlabel('Time (s)');
ylabel('Amplitude');

title('Sensor Signal Filtering Comparison');

legend('Clean signal','Noisy signal', ...
       'FIR output','IIR output');

saveas(gcf,'sensor-time-comparison.png');

%% 7. FIGURE 2: FILTER FREQUENCY RESPONSES

[HFIR,fFIR] = freqz(bFIR,1,4096,Fs);

[HIIR,fIIR] = freqz(bIIR,aIIR,4096,Fs);

figure('Name','Sensor Filter Responses','Color','w');

plot(fFIR,20*log10(max(abs(HFIR),1e-10)), ...
    'b','LineWidth',1.3);

hold on;

plot(fIIR,20*log10(max(abs(HIIR),1e-10)), ...
    'r','LineWidth',1.3);

xline(fc,'k--','20 Hz cutoff');

grid on;

xlim([0 150]);
ylim([-100 5]);

xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');

title('FIR and IIR Low-Pass Filter Responses');

legend('FIR Order 60','Butterworth IIR Order 4');

saveas(gcf,'sensor-filter-responses.png');

%% 8. FIGURE 3: SENSOR FREQUENCY SPECTRA

N = length(x);

Y_noisy = fft(x);
Y_FIR = fft(yFIR);
Y_IIR = fft(yIIR);

P_noisy = abs(Y_noisy/N);
P_FIR = abs(Y_FIR/N);
P_IIR = abs(Y_IIR/N);

P_noisy = P_noisy(1:N/2+1);
P_FIR = P_FIR(1:N/2+1);
P_IIR = P_IIR(1:N/2+1);

P_noisy(2:end-1) = 2*P_noisy(2:end-1);
P_FIR(2:end-1) = 2*P_FIR(2:end-1);
P_IIR(2:end-1) = 2*P_IIR(2:end-1);

f = Fs*(0:N/2)/N;

figure('Name','Sensor Spectra','Color','w');

plot(f,P_noisy,'Color',[0.6 0.6 0.6]);
hold on;

plot(f,P_FIR,'b','LineWidth',1.2);

plot(f,P_IIR,'r','LineWidth',1.2);

xline(5,'k:','5 Hz');
xline(12,'k:','12 Hz');
xline(50,'m:','50 Hz');
xline(137,'g:','137 Hz');

grid on;

xlim([0 200]);

xlabel('Frequency (Hz)');
ylabel('Amplitude');

title('Sensor Single-Sided Amplitude Spectra');

legend('Noisy signal','FIR output','IIR output');

saveas(gcf,'sensor-spectra.png');

%% 9. FIGURE 4: RMSE COMPARISON

figure('Name','RMSE Comparison','Color','w');

bar([rmseNoisy rmseFIR rmseIIR]);

set(gca,'XTickLabel',{'Noisy','FIR','IIR'});

ylabel('RMSE');

title('RMSE Comparison with Clean Signal');

grid on;

saveas(gcf,'sensor-rmse.png');

%% ========================================================
% PART B: AUDIO HUM REMOVAL
% =========================================================

fprintf('\n--- PART B: AUDIO FILTERING ---\n');

%% 10. LOAD HANDEL AUDIO

load handel;

xClean = y(:);

tAudio = (0:numel(xClean)-1)'/Fs;

fprintf('Audio sampling frequency: %d Hz\n',Fs);

fprintf('Audio duration: %.2f seconds\n', ...
    length(xClean)/Fs);

if Fs <= 102
    error('Sampling frequency must be greater than 102 Hz.');
end

%% 11. ADD CONTROLLED 50 Hz HUM

hum = 0.15*sin(2*pi*50*tAudio);

xHum = xClean + hum;

%% 12. DESIGN NARROW NOTCH FILTER

% Stop band: 49 to 51 Hz

[bN,aN] = butter(2,[49 51]/(Fs/2),'stop');

% Apply zero-phase filtering

yAudio = filtfilt(bN,aN,xHum);

%% 13. DESIGN WIDE NOTCH FILTER

% Stop band: 45 to 55 Hz

[bWide,aWide] = butter(2,[45 55]/(Fs/2),'stop');

% Apply zero-phase filtering

yWide = filtfilt(bWide,aWide,xHum);

%% 14. FIGURE 5: AUDIO WAVEFORM COMPARISON

figure('Name','Audio Waveform Comparison','Color','w');

idxAudio = tAudio <= 0.2;

plot(tAudio(idxAudio),xClean(idxAudio), ...
    'k','LineWidth',1.2);

hold on;

plot(tAudio(idxAudio),xHum(idxAudio), ...
    'Color',[0.7 0.7 0.7]);

plot(tAudio(idxAudio),yAudio(idxAudio), ...
    'b','LineWidth',1.2);

plot(tAudio(idxAudio),yWide(idxAudio), ...
    'r','LineWidth',1.2);

grid on;

xlabel('Time (s)');
ylabel('Amplitude');

title('Audio Waveform Before and After Filtering');

legend('Clean audio','Hum added', ...
       'Narrow notch','Wide notch');

saveas(gcf,'audio-waveform.png');

%% 15. FIGURE 6: AUDIO FREQUENCY SPECTRA

Na = length(xClean);

YC = fft(xClean);
YH = fft(xHum);
YN = fft(yAudio);
YW = fft(yWide);

PC = abs(YC/Na);
PH = abs(YH/Na);
PN = abs(YN/Na);
PW = abs(YW/Na);

PC = PC(1:floor(Na/2)+1);
PH = PH(1:floor(Na/2)+1);
PN = PN(1:floor(Na/2)+1);
PW = PW(1:floor(Na/2)+1);

if rem(Na,2) == 0

    PC(2:end-1) = 2*PC(2:end-1);
    PH(2:end-1) = 2*PH(2:end-1);
    PN(2:end-1) = 2*PN(2:end-1);
    PW(2:end-1) = 2*PW(2:end-1);

else

    PC(2:end) = 2*PC(2:end);
    PH(2:end) = 2*PH(2:end);
    PN(2:end) = 2*PN(2:end);
    PW(2:end) = 2*PW(2:end);

end

fa = Fs*(0:floor(Na/2))/Na;

figure('Name','Audio Spectra','Color','w');

plot(fa,PC,'k');
hold on;

plot(fa,PH,'r');
plot(fa,PN,'b');
plot(fa,PW,'g');

xline(50,'m--','50 Hz');

grid on;

xlim([0 500]);

xlabel('Frequency (Hz)');
ylabel('Amplitude');

title('Audio Frequency Spectrum Comparison');

legend('Clean audio','Hum added', ...
       'Narrow notch','Wide notch');

saveas(gcf,'audio-spectra.png');

%% 16. FIGURE 7: NOTCH FILTER RESPONSES

[HN,fN] = freqz(bN,aN,4096,Fs);

[HW,fW] = freqz(bWide,aWide,4096,Fs);

figure('Name','Notch Filter Responses','Color','w');

plot(fN,20*log10(max(abs(HN),1e-10)), ...
    'b','LineWidth',1.2);

hold on;

plot(fW,20*log10(max(abs(HW),1e-10)), ...
    'r','LineWidth',1.2);

xline(50,'k--','50 Hz');

grid on;

xlim([0 120]);
ylim([-100 5]);

xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');

title('Narrow and Wide Notch Filter Responses');

legend('49-51 Hz','45-55 Hz');

saveas(gcf,'audio-notch-responses.png');

%% 17. MEASURE ACTUAL 50 Hz HUM REDUCTION

% Filter only the known added hum.
% This separates the added hum from the original audio.

filteredHumNarrow = filtfilt(bN,aN,hum);

filteredHumWide = filtfilt(bWide,aWide,hum);

% Compare RMS values of the added hum.

humRMS = sqrt(mean(hum.^2));

narrowHumRMS = sqrt(mean(filteredHumNarrow.^2));

wideHumRMS = sqrt(mean(filteredHumWide.^2));

% Calculate measured attenuation.

narrowAttenuation = 20*log10( ...
    max(narrowHumRMS,1e-12)/humRMS);

wideAttenuation = 20*log10( ...
    max(wideHumRMS,1e-12)/humRMS);

fprintf('\n--- ACTUAL HUM REDUCTION ---\n');

fprintf('Original hum RMS: %.8f\n',humRMS);

fprintf('Narrow filtered hum RMS: %.8f\n',narrowHumRMS);

fprintf('Wide filtered hum RMS: %.8f\n',wideHumRMS);

fprintf('Narrow notch attenuation: %.2f dB\n', ...
    narrowAttenuation);

fprintf('Wide notch attenuation: %.2f dB\n', ...
    wideAttenuation);

%% 18. PLAY AUDIO AT SAME PLAYBACK GAIN

fprintf('\nPlaying audio with 50 Hz hum...\n');

sound(xHum,Fs);

pause(length(xHum)/Fs + 1);

fprintf('Playing narrow-filtered audio...\n');

sound(yAudio,Fs);

pause(length(yAudio)/Fs + 1);

fprintf('Playing wide-filtered audio...\n');

sound(yWide,Fs);

%% 19. FINAL SUMMARY

fprintf('\n========================================\n');

fprintf('ASSIGNMENT COMPLETED SUCCESSFULLY\n');

fprintf('========================================\n');

fprintf('\nSENSOR RMSE RESULTS:\n');

fprintf('Noisy: %.6f\n',rmseNoisy);

fprintf('FIR: %.6f\n',rmseFIR);

fprintf('IIR: %.6f\n',rmseIIR);

fprintf('\nAUDIO HUM ATTENUATION:\n');

fprintf('Narrow notch: %.2f dB\n',narrowAttenuation);

fprintf('Wide notch: %.2f dB\n',wideAttenuation);

fprintf('\nAll seven figures saved successfully.\n');

