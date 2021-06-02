%% Variables
Fs = 10;  % Sampling Frequency
M    = 20;       % Order
Fc1  = 2;        % First Cutoff Frequency
Fc2  = 3;        % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
 
FFTSize = 256;
t = {'RECTANGULAR', 'KAIASER', 'BANTLETT', 'HAMMING', 'HANN'};
titles= string(t);
 
for f=1:5
    figure(f);    
    subplot(3,3,1);
    
    for i=1:3
        N = M*i;
 
        % RECTANGULAR BPF 
        win = rectwin(N+1);
        rect  = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
 
        % KAIASER LPF 
        Beta = 0.5;      % Window Parameter
 
        win = kaiser(N+1, Beta);
        kais  = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
 
         %BANTLETT LPF
        win = bartlett(N+1);
        hant  = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
        
        win = hamming(N+1);
        hm = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
        
        win = hann(N+1);
        hn  = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
        
        LPF = [rect; kais; hant; hm; hn];
        
        subplot(3,3,3*i-2)
        stem(LPF(f,:));
        title([titles(f)+' M = '+num2str(N/2) ])
        subplot(3,3,3*i-1)
        plot(abs(fft(LPF(f,:),FFTSize)))
        title('MAGNITUDE')
        subplot(3,3,3*i)
        plot(phase(fft(LPF(f,:),FFTSize)))
        title('PHASE')
    end
end
