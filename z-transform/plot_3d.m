figure;

%% plot method 1 - meshgrid
subplot(2, 1, 1);
[X, Y] = meshgrid(-2: 0.05: 2);
z = -1 .* (cos(X) + 1i .* sin(Y)) ./ (cos(X) + 1i .* sin(Y) - 0.5);
x_z =  (0.5)^z;
mesh(X, Y, abs(z));
axis([-2 2 -2 2 0 4]);

%% plot method 2 - plot3
subplot(2, 1, 2);
t = 0:0.1:10*pi;
x = exp(-0.05 * t) .* sin(t);
y = exp(-0.05 * t) .* cos(t);
z = t;
plot3(x, y, z);