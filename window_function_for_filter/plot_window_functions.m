% Plot various window functions
clc;clear;
PLOT_RANGE = 50;
fft_size = [ 128 1024 ];
index_size_128 = 0:2*pi/127:2*pi;
index_size_1024 = 0:2*pi/1023:2*pi;
t = -PLOT_RANGE:1:PLOT_RANGE;

rect_10 = rect_window(10, PLOT_RANGE); rect_40 = rect_window(40, PLOT_RANGE);
bartlett_10 = bartlett_window(10, PLOT_RANGE); bartlett_40 = bartlett_window(40, PLOT_RANGE);
hamming_10 = hamming_window(10, PLOT_RANGE); hamming_40 = hamming_window(40, PLOT_RANGE);
hann_10 = hann_window(10, PLOT_RANGE); hann_40 = hann_window(40, PLOT_RANGE);
blackman_10 = blackman_window(10, PLOT_RANGE); blackman_40 = blackman_window(40, PLOT_RANGE);

windows = [ rect_10 
            rect_40
            bartlett_10 
            bartlett_40
            hamming_10
            hamming_40
            hann_10 
            hann_40
            blackman_10 
            blackman_40 
        ];

names = [ "rect, M = 10" 
        "rect, M = 40"
        "bartlett, M = 10" 
        "bartlett, M = 40"
        "hamming, M = window10" 
        "hamming, M = window40"
        "hann, M = window10" 
        "hann, M = window40"
        "blackman, M = window10" 
        "blackman, M = window40" 
        ];
    
names2 = [ "|W_{rect}|, M = 10" "20log|W|, M = 10" "|W_{rect}|, M = 40" "20log|W|, M = 40"
        "|W_{bartlett}|, M = 10" "20log|W|, M = 10" "|W_{bartlett}|, M = 40" "20log|W|, M = 40"
        "|W_{hamming}|, M = 10" "20log|W|, M = 10" "|W_{hamming}|, M = 40" "20log|W|, M = 40"
        "|W_{hann}|, M = 10" "20log|W|, M = 10" "|W_{hann}|, M = 40" "20log|W|, M = 40"
        "|W_{blackman}|, M = 10" "20log|W|, M = 10" "|W_{blackman}|, M = 40" "20log|W|, M = 40"
        ];

figure(1)
for i = 1:10
    subplot(5,2,i);
    plot(t, windows(i,:));
    title(names(i))
    axis([-50 50 0 1]);
end

for j = 1:2
    figure(j+1)
    for i = 0:4
        freq_signal_10 = abs(fft(windows(i*2 + 1,:), fft_size(j)));
        freq_signal_40 = abs(fft(windows(i*2 + 2,:), fft_size(j)));

        if j == 1
            index_size = index_size_128;
        else
            index_size = index_size_1024;
        end

        subplot(5,4,i*4+1);
        norm_freq_signal_10 = [index_size; freq_signal_10 - freq_signal_10(1)]';
        plot(norm_freq_signal_10(:,1), norm_freq_signal_10(:,2));
        title(names2(i+1,1))

        subplot(5,4,i*4+2);
        log_scale_10 = 20*log(freq_signal_10);
        norm_log_scale_10 = [index_size; log_scale_10 - log_scale_10(1)]';
        plot(norm_log_scale_10(:,1), norm_log_scale_10(:,2));
        title(names2(i+1,2))

        subplot(5,4,i*4+3);
        norm_freq_signal_40 = [index_size; freq_signal_40 - freq_signal_40(1)]';
        plot(norm_freq_signal_40(:,1), norm_freq_signal_40(:,2));
        title(names2(i+1,3))

        subplot(5,4,i*4+4);
        log_scale_40 = 20*log(freq_signal_40);
        norm_log_scale_40 = [index_size; log_scale_40 - log_scale_40(1)]';
        plot(norm_log_scale_40(:,1), norm_log_scale_40(:,2));
        title(names2(i+1,4))
    end
end

%% Window Funtions

function output = rect_window(N, range)
    output = [];
    for i = -range:range
        if i < -N | i > N
            output = [output 0];
        else
            output = [output 1];
        end
    end
end

function output = bartlett_window(N, range)
    output = [];
    for i = -range:range
        if i < -N | i > N
            output = [output 0];
        else
            if i <= 0
                output = [output 1+i/N];
            else
                output = [output 1-i/N];
            end
        end
    end
end

function output = hamming_window(N, range)
    output = [];
    for i = -range:range
        if i < -N | i > N
            output = [output 0];
        else
            output = [output 0.54-0.46*cos(2*pi*(i+N) / (2*N) )];
        end
    end
end

function output = hann_window(N, range)
    output = [];
    for i = -range:range
        if i < -N | i > N
            output = [output 0];
        else
            output = [output 0.5-0.5*cos(2*pi*(i+N) / (2*N) )];
        end
    end
end

function output = blackman_window(N, range)
    output = [];
    for i = -range:range
        if i < -N | i > N
            output = [output 0];
        else
            output = [output 0.42-0.5*cos(2*pi*(i+N) / (2*N)) + 0.08 * cos(4*pi*(i+N) / (2*N))];
        end
    end
end