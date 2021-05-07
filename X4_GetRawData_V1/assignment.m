%% Load Notes

% Read Note data is already collected from X4

% raw_data_ori (= Band Pass Filter Adapted Result)
raw_data = load('RawData1.mat').RawData1(300, :);
raw_data_ori = load('RawData_Ori1.mat').RawData_Ori1(300, :);
%% Setup Variables

fs = 44100; % Sampling Freq
fft_size = 2^16; % FFT Size

x_step = fs * ((1:1:fft_size) - 1) / fft_size;

fft_note1 = abs(fft(raw_data, fft_size));
fft_note2 = abs(fft(raw_data_ori, fft_size));
%% Plotting

subplot(2, 1, 1)
hold on
title("Before Band Pass Filtering")
plot(x_step, fft_note1)

subplot(2, 1, 2)
hold on
title("After Band Pass Filtering")
plot(x_step, fft_note2)