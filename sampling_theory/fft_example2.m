f_0 = 20;
f_s = 100;

fft_size = 2^11;
n = 0:1:1000;
x_axis = 0:1:(fft_size - 1);

signal = cos(2*pi*f_0 / f_s * n);
fft_signal = fft(signal, fft_size);
abs_fft_signal = abs(fft_signal);

plot(x_axis, abs_fft_signal);
axis([0 fft_size -inf inf]);