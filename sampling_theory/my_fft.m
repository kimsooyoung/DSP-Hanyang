function [X, n] = my_fft(x, N)
%my_fft - Get sinal and fft size / Return output signal and freq index
%
% Syntax: [X, n] = my_fft(x, N)
%
% simple function for return FFT index

    fft_signal = fft(x, N);
    X = abs(fft_signal);

    n_0 = find(X < 12 & X > 8);
    n_0 = n_0(1);
    
    % n = n_0;
    n = round((n_0 * 44100) / (N * 1000), 2);

end