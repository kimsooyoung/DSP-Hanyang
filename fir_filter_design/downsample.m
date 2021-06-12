clear; close all;

M = 50; % window size
n = 0:1:49;
t = 0:1:255;

fft_size = 2^9;
pi_index = (1:fft_size)/fft_size * 2*pi;

x_n = sin(0.2*pi*n);

%% 
x_n_triple = [];

for i=1:length(n)
    x_n_triple = [ x_n_triple x_n(i) 0 0 ];
end

rect_window = rectwin(M+1);
lpf = fir1(M, 0.25, 'low', rect_window);
lpf2 = fir1(M, 0.1, 'low', rect_window);

figure(1);
subplot(2,1,1); stem(x_n); title("x_n");
subplot(2,2,3); stem(x_n_triple); title("x_3 n");  
subplot(2,2,4); stem(lpf2); title("LPF2, Rect Window with Size 50");
%%
x_n_zero_filled = [ x_n zeros(1, 206) ];
x_n_triple_zero_filled = [ x_n_triple zeros(1, 106) ];

fft_x_n_abs = abs(fft(x_n_zero_filled, fft_size));
fft_x_triple_abs = abs(fft(x_n_triple_zero_filled, fft_size)); fft_lpf_abs2 = abs(fft(lpf2, fft_size));

figure(2);
subplot(2,1,1); plot(pi_index, fft_x_n_abs); title("|X(omega)|");
subplot(2,2,3); plot(pi_index, fft_x_triple_abs); title("|X_3(omega)|"); 
subplot(2,2,4); plot(pi_index, fft_lpf_abs2); title("|H(omega)|");
%%
y_3_omega = fft(x_n_triple_zero_filled, fft_size) .* fft(lpf2, fft_size); y_3_n = ifft(y_3_omega);

figure(3);
subplot(2,1,1); plot(pi_index, abs(y_3_omega)); title("|Y_3(omega)|"); 
subplot(2,1,2); stem(y_3_n); title("y_3(n)"); xlim([41 125]);
%%
downsample_y = [];
for i=1:length(y_3_n)
    if rem(i,2) == 0
        downsample_y = [ downsample_y y_3_n(i) ];
    end
end                                           

fft_downsample_y = fft(downsample_y, fft_size);

figure(4);
subplot(2,1,1); stem(downsample_y); title("downsample_y"); xlim([20 60]);
subplot(2,1,2); plot(pi_index, abs(fft_downsample_y)); title("fft_downsample_y");  
% downsample_y