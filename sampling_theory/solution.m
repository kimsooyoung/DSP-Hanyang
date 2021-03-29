figure(1);

fs = 44100;
fft_size = 2^11;

plot(((1:1:fft_size) - 1) / fft_size * fs, abs(fft(Example_Data1, fft_size)));
hold on
plot(((1:1:fft_size) - 1) / fft_size * fs, abs(fft(Example_Data2, fft_size)));
hold on
plot(((1:1:fft_size) - 1) / fft_size * fs, abs(fft(Example_Data3, fft_size)));
hold on
plot(((1:1:fft_size) - 1) / fft_size * fs, abs(fft(Example_Data4, fft_size)));
hold on

title('2993Hz, 6696Hz, 7515Hz, 8656Hz')