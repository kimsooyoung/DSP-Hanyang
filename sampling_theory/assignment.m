figure(1);

% sampling freq fs, ( 2 * f_0 < f_s )
fs = 44100;
fft_size = 2^11;

%% Load Samples
example_data1 = load('Example_Data.mat', 'Example_Data1').Example_Data1;
example_data2 = load('Example_Data.mat', 'Example_Data2').Example_Data2;
example_data3 = load('Example_Data.mat', 'Example_Data3').Example_Data3;
example_data4 = load('Example_Data.mat', 'Example_Data4').Example_Data4;

axis_x = 0:1:(fft_size - 1);
%% Calculate Maximum Values

% use function assigned in "my_fft.m"
hold on
[ X1, n1 ] = my_fft(example_data1, fft_size);
plot(axis_x, X1);

hold on
[ X2, n2 ] = my_fft(example_data2, fft_size);
plot(axis_x, X2);

hold on
[ X3, n3 ] = my_fft(example_data3, fft_size);
plot(axis_x, X3);

hold on
[ X4, n4 ] = my_fft(example_data4, fft_size);
plot(axis_x, X4);

%% Plot Options
title(['A ', num2str(n1), 'kHz, ' , ' B ', num2str(n2), 'kHz, ' , ' C ', num2str(n3), 'kHz, ' , ' D ', num2str(n4), 'kHz' ])

axis([0 fft_size-1 -inf inf])
