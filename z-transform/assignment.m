%% inverse z-transform check using syms
syms n positive
syms a b z

X_z = -z / (z - 0.5);
x_n = iztrans(X_z);

% Result => x_n = -(1/2)^n
%% Variables Setup

fft_size = 2^12;
N = 20;
t = 0: 1: 20;
x_c = zeros(1, fft_size + 1);

w = linspace(0, 2 * pi, fft_size + 1);
%% plot 1 - meshgrid

subplot(1, 2, 1);
[mesh_x, mesh_y] = meshgrid(-2: 0.05: 2);
mesh_z = -1 .* (mesh_x + 1i*mesh_y ) ./ (mesh_x + 1i*mesh_y - 0.5);

mesh(mesh_x, mesh_y, abs(mesh_z));
axis([-2 2 -2 2 0 12]);
%% plot 2 - z-transfrom result when r = 1, using plot3()

x = 0.5 .^ t;
z = exp(-1j*w);

for i = 1:N
    x_c = x_c + x(i) * z.^(i-1);
end

hold on
plot3(real(z), imag(z), abs(x_c))
%% plot 3 - unfold 3D plots to 2D

subplot(2, 2, 2);
plot(w, abs(x_c))
title("Z = e^{-jwn}")
%% plot 4 - FFT result 
% When r = 1, the result of the z transformation is the same as that of fft.

subplot(2, 2, 4);
fft_x = abs(fft(x, fft_size + 1));
plot(w, fft_x)
title("FFT Result")