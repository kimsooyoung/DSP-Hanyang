clear; close all;

M = 50;
n = 0:1:200;
x_n = cos(0.1*pi*n) + cos(0.3*pi*n) + cos(0.4*pi*n);

figure(1);
plot(n, x_n)
%% Freq Domain Plot
figure(2);
for i=0:1
    x_omega = abs(fft(x_n, 2^(i*6+6)));
    subplot(2,2,i*2+1); plot(x_omega);
    title("|X(omega)|")

    x_log = log(x_omega) * 20; 
    subplot(2,2,i*2+2); plot(x_log);
    title("20log|X(omega)|")
end
%% Filter Plot - time domain
figure(3);

rect_window = rectwin(M+1);
lpf = fir1(M,0.2, 'low', rect_window);
bpf = fir1(M, [0.2 0.35]);
hpf = fir1(M,0.35,'high', rect_window);

subplot(3,1,1); plot(lpf);
subplot(3,1,2); plot(bpf);
subplot(3,1,3); plot(hpf);
%% Filter Plot - freq domain
figure(4);

lpf_omega = abs(fft(lpf, 2^9));
bpf_omega = abs(fft(bpf, 2^9));
hpf_omega = abs(fft(hpf, 2^9));

subplot(3,2,1); plot(lpf_omega);
subplot(3,2,2); plot(log(lpf_omega) * 20);

subplot(3,2,3); plot(bpf_omega);
subplot(3,2,4); plot(log(bpf_omega) * 20);

subplot(3,2,5); plot(hpf_omega);
subplot(3,2,6); plot(log(bpf_omega) * 20);
%% Adapt Filter to Signal
figure(5);

x_n_fft = fft(x_n, 2^9);
x_n_fft_abs = abs(x_n_fft);

y_n_lpf = x_n_fft_abs .* lpf_omega;
y_n_bpf = x_n_fft_abs .* bpf_omega;
y_n_hpf = x_n_fft_abs .* hpf_omega;

subplot(3,1,1); plot(y_n_lpf);
subplot(3,1,2); plot(y_n_bpf);
subplot(3,1,3); plot(y_n_hpf);

%% Restore Signal
figure(6);

y_1 = ifft(x_n_fft .* lpf_omega);
y_2 = ifft(x_n_fft .* bpf_omega);
y_3 = ifft(x_n_fft .* hpf_omega);

subplot(3,1,1); plot(y_1); xlim([51 200]);
subplot(3,1,2); plot(y_2); xlim([51 200]);
subplot(3,1,3); plot(y_3); xlim([51 200]);