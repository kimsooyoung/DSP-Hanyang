%% Play and Plot Music Signal

[my_song, fs] = audioread('noisy_song.wav');
fft_size = 2^16;

% sound(my_song, fs)
% plot(my_song);
%% Load Filters

% use 2 differenct filters
% one of 40 order the other is 223 order
order_40_filter = load('order_40_filter.mat').lpf;
order_223_filter = load('order_223_filter.mat').lpf;

% order_test_filter = load('test_filter.mat').lpf;
%% Apply Filters with conv function

conv_result = conv(my_song, order_40_filter);
conv_result2 = conv(my_song, order_223_filter);

% CAUTION!! This music sounds noisy, care your ears
sound(conv_result2, fs)

x_step = ((1:1:fft_size) - 1) / fft_size * fs;
%% FFT process

original_song_fft = abs(fft(my_song, fft_size));
fft_note1 = abs(fft(conv_result, fft_size));
fft_note2 = abs(fft(conv_result2, fft_size));
fft_note3 = abs(fft(conv_result3, fft_size));
%% Plot results

subplot(3, 1, 1)
axis([0 8000 0 1000])
hold on
title("Original Signal")
plot(x_step, original_song_fft)

subplot(3, 1, 2)
axis([0 8000 0 1000])
hold on
title("40 order filter")
plot(x_step, fft_note1)

subplot(3, 1, 3)
axis([0 8000 0 1000])
hold on
title("223 order filter")
plot(x_step, fft_note2)