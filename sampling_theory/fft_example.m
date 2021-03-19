fs = 10;

f1 = 3;
f2 = 7;

t = 0:1/fs:3;
t_c = 0:0.00001:3
N = length(t);
fft_size = 2^15;

y1 = sin(2 * pi * f1 * t);
y2 = sin(2 * pi * f2 * t);
y3 = sin(2 * pi * f1 * t_c);

subplot(2, 1, 1)
plot(t, y1, 'bx:')
hold on

plot(t, y2, 'r+:')
plot(t_c, y3, 'k')
hold off

subplot(2, 1, 2)
plot((0:fft_size - 1) / fft_size * fs, abs(fft(y1, fft_size)))
hold on
plot((0:fft_size - 1) / fft_size * fs, abs(fft(y2, fft_size)), '--')
hold off


