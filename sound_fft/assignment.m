%% Load Notes

% Read Note data is brushed from cannon_sample.wav
% Load ALL those Notes

% First Row contains index, So seconds rows are imported
note1 = load('note_1.mat').brushedData1(:,2);
note2 = load('note_2.mat').brushedData2(:,2);
note3 = load('note_3.mat').brushedData3(:,2);
note4 = load('note_4.mat').brushedData4(:,2);
note5 = load('note_5.mat').brushedData5(:,2);
note6 = load('note_6.mat').brushedData6(:,2);
note7 = load('note_7.mat').brushedData7(:,2);
note8 = load('note_8.mat').brushedData8(:,2);

%% Setup Variables

fs = 44100;
fft_size = 2^16;

% sound(note1, fs);
% sound(note2, fs);
% sound(note3, fs);
% sound(note4, fs);
% sound(note5, fs);
% sound(note6, fs);
% sound(note7, fs);
% sound(note8, fs);

x_step = fs * ((1:1:fft_size) - 1) / fft_size;

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
axis([0 500 0 1500])
hold on
title("3옥타브 도")
plot(x_step, fft_note1)

subplot(4, 2, 2)
axis([0 500 0 1000])
hold on
title("2옥타브 솔")
plot(x_step, fft_note2)

subplot(4, 2, 3)
axis([0 500 0 1000])
hold on
title("2옥타브 라")
plot(x_step, fft_note3)

subplot(4, 2, 4)
axis([0 500 0 1000])
hold on
title("2옥타브 미")
plot(x_step, fft_note4)

subplot(4, 2, 5)
axis([0 500 0 1000])
hold on
title("2옥타브 파")
plot(x_step, fft_note5)

subplot(4, 2, 6)
axis([0 500 0 1000])
hold on
title("2옥타브 도")
plot(x_step, fft_note6)

subplot(4, 2, 7)
axis([0 500 0 1000])
hold on
title("2옥타브 파")
plot(x_step, fft_note7)

subplot(4, 2, 8)
axis([0 500 0 1000])
hold on
title("2옥타브 솔")
plot(x_step, fft_note8)