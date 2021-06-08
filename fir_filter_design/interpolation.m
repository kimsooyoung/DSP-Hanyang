clear; close all;

M = 50; % window size
n = 0:1:49;
t = 0:1:255;

fft_size = 2^9;
pi_index = (1:fft_size)/fft_size * 2*pi;

x_n = sin(0.2*pi*n);

%% 
x_n_doubled = [];
x_n_triple = [];

for i=1:length(n)
    x_n_doubled = [ x_n_doubled  x_n(i) 0 ];
    x_n_triple = [ x_n_triple x_n(i) 0 0 ];
end

rect_window = rectwin(M+1);
lpf = fir1(M, 0.25, 'low', rect_window);
lpf2 = fir1(M, 0.1, 'low', rect_window);

figure(1);
subplot(3,1,1); stem(x_n); title("x_n");
subplot(3,2,3); stem(x_n_doubled); title("x_2 n"); subplot(3,2,4); stem(lpf); title("LPF, Rect Window with Size 50");
subplot(3,2,5); stem(x_n_triple); title("x_3 n");  subplot(3,2,6); stem(lpf2); title("LPF2, Rect Window with Size 50");
%%
x_n_zero_filled = [ x_n zeros(1, 206) ];
x_n_doubled_zero_filled = [ x_n_doubled zeros(1, 156) ];
x_n_triple_zero_filled = [ x_n_triple zeros(1, 106) ];

fft_x_n_abs = abs(fft(x_n_zero_filled, fft_size));
fft_x_double_abs = abs(fft(x_n_doubled_zero_filled, fft_size)); fft_lpf_abs = abs(fft(lpf, fft_size));
fft_x_triple_abs = abs(fft(x_n_triple_zero_filled, fft_size)); fft_lpf_abs2 = abs(fft(lpf2, fft_size));

figure(2);
subplot(3,1,1); plot(pi_index, fft_x_n_abs); title("|X(omega)|");
subplot(3,2,3); plot(pi_index, fft_x_double_abs); title("|X_2(omega)|"); subplot(3,2,4); plot(pi_index, fft_lpf_abs); title("|H(omega)|");
subplot(3,2,5); plot(pi_index, fft_x_triple_abs); title("|X_3(omega)|"); subplot(3,2,6); plot(pi_index, fft_lpf_abs2); title("|H(omega)|");
%%
y_2_omega = fft(x_n_doubled_zero_filled, fft_size) .* fft(lpf, fft_size); y_2_n = ifft(y_2_omega);
y_3_omega = fft(x_n_triple_zero_filled, fft_size) .* fft(lpf2, fft_size); y_3_n = ifft(y_3_omega);

figure(3);
subplot(2,2,1); plot(pi_index, abs(y_2_omega)); title("|Y_2(omega)|"); subplot(2,2,2); stem(y_2_n); title("y_2(n)"); xlim([50 125]);
subplot(2,2,3); plot(pi_index, abs(y_3_omega)); title("|Y_3(omega)|"); subplot(2,2,4); stem(y_3_n); title("y_3(n)"); xlim([41 125]);