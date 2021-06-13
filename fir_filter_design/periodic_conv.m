clear; close all;

M = 50; % window size
n_1 = 0:1:29;
n_2 = 0:1:99;
fft_size = 128;

x_n = rectwin(40+1);
y_n = rectwin(100+1);
linear_conv = conv(x_n, y_n);

fft_x_n = (fft(x_n, fft_size));
fft_y_n = (fft(y_n, fft_size));

periodic_conv_freq = fft_x_n .* fft_y_n;
periodic_conv_result = ifft(periodic_conv_freq, 128);

figure(1);
subplot(2,2,1); plot(x_n);xlim([0 100])
subplot(2,2,2); plot(abs(fft_x_n));
subplot(2,2,3); plot(y_n);xlim([0 100])
subplot(2,2,4); plot(abs(fft_y_n));

figure(2);
subplot(2,1,1); plot(linear_conv);
subplot(2,1,2); plot(abs(periodic_conv_result));
