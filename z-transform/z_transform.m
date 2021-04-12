%% Z transform 3D plot
fft_size = 2^12;
N = 20; 
t = 0: 1: 20;
% x = ones(1, N);
x = 0.5 .^ t;
x_c = zeros(1, fft_size + 1);

w = linspace(0, 2 * pi, fft_size + 1);

z = exp(-1j*w);

for i = 1:N
    x_c = x_c + x(i) * z.^(i-1);
end

hold on
% subplot(1, 2, 1);
plot3(real(z), imag(z), abs(x_c))

subplot(2, 2, 2);
plot(w, abs(x_c))

subplot(2, 2, 4);
fft_x = abs(fft(x, fft_size + 1));
plot(w, fft_x)