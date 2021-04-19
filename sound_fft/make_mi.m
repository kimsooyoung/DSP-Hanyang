%% Make 4 octave Mi

% Sampling Frequency
Fs = 48000;

Fo = 329.6276;
L = 1:1:(3*Fs);
A = 2;

Mi = A * cos(2 * pi * Fo / Fs * L);
% sound(Mi, Fs)
% plot(Mi)

%% Fade Off with linspace

Mi_lin = Mi .* linspace(1, 0, length(Mi));

sound(Mi_lin, Fs);
plot(Mi_lin)