%% Load Notes

% Read Note data is brushed from cannon_sample.wav
% Load ALL those Notes

% First Row contains index, So seconds rows are imported
note1 = load('Note1.mat').Note1(:,2);
note2 = load('Note2.mat').Note2(:,2);
note3 = load('Note3.mat').Note3(:,2);
note4 = load('Note4.mat').Note4(:,2);
note5 = load('Note5.mat').Note5(:,2);
note6 = load('Note6.mat').Note6(:,2);
note7 = load('Note7.mat').Note7(:,2);
note8 = load('Note8.mat').Note8(:,2);


%% 

fs = 44100;
fft_size = 2^11;

% sound(note1, fs);
sound(note2, fs);
% sound(note3, fs);
% sound(note4, fs);
% sound(note5, fs);
% sound(note6, fs);
% sound(note7, fs);
% sound(note8, fs);

x_step = ((1:1:fft_size) - 1) / fft_size * fs;

% fft_note1 = my_fft(note1, fft_size);
% fft_note2 = my_fft(note2, fft_size);
% fft_note3 = my_fft(note3, fft_size);
% fft_note4 = my_fft(note4, fft_size);
% fft_note5 = my_fft(note5, fft_size);
% fft_note6 = my_fft(note6, fft_size);
% fft_note7 = my_fft(note7, fft_size);
% fft_note8 = my_fft(note8, fft_size);

fft_note1 = abs(fft(note1, fft_size));
fft_note2 = abs(fft(note2, fft_size));
fft_note3 = abs(fft(note3, fft_size));
fft_note4 = abs(fft(note4, fft_size));
fft_note5 = abs(fft(note5, fft_size));
fft_note6 = abs(fft(note6, fft_size));
fft_note7 = abs(fft(note7, fft_size));
fft_note8 = abs(fft(note8, fft_size));



%% Plotting

subplot(4, 2, 1)
axis([0 500 0 100])
hold on
title("3옥타브 도")
plot(x_step, fft_note1)

subplot(4, 2, 2)
axis([0 500 0 100])
hold on
title("2옥타브 솔")
plot(x_step, fft_note2)

subplot(4, 2, 3)
axis([0 500 0 100])
hold on
title("2옥타브 라")
plot(x_step, fft_note3)

subplot(4, 2, 4)
axis([0 500 0 100])
hold on
title("2옥타브 미")
plot(x_step, fft_note4)

subplot(4, 2, 5)
axis([0 500 0 100])
hold on
title("2옥타브 파")
plot(x_step, fft_note5)

subplot(4, 2, 6)
axis([0 500 0 100])
hold on
title("2옥타브 도")
plot(x_step, fft_note6)

subplot(4, 2, 7)
axis([0 500 0 100])
hold on
title("2옥타브 파")
plot(x_step, fft_note7)

subplot(4, 2, 8)
axis([0 500 0 100])
hold on
title("2옥타브 솔")
plot(x_step, fft_note8)

%% 

function fft_result = my_fft(x, fft_size)
% my_fft - Input: sinal / fft size / sampling frequency
%
% Syntax: fft_result = my_fft(x, N)
%
% simple function for plotting FFT results

    fft_result = abs(fft(x, fft_size));

end