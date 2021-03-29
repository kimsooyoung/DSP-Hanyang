%% Play and Plot Music Signal

[my_song, fs] = audioread('cannon_sample.wav');

sound(my_song, fs)
plot(my_song)