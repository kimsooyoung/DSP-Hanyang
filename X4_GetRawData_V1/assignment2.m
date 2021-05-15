%% Load Data

% Read Data already collected from X4

raw_data = load('R_Data.mat').RawData1;
hilbert_history = load('H_History.mat').HilbertHistory;
distance_history = load('D_History.mat').DistanceHistory;
alpha1_history = load('BLP_1.mat').B_LowPass1;
alpha2_history = load('BLP_2.mat').B_LowPass2;
%% 
close all;

figure;
mesh(hilbert_history);
title("2015036580 김수영")

figure;
plot(distance_history);
title("2015036580 김수영")

%% 
figure;
subplot(3, 1, 1)
hold on
plot(raw_data(780, :));
title("Raw Data 780")

subplot(3, 1, 2)
hold on
plot(raw_data(781, :));
title("Raw Data 781")

subplot(3, 1, 3)
hold on
plot(raw_data(782, :));
title("Raw Data 782")

figure;
subplot(3, 1, 1)
hold on
plot(raw_data(781, :));
title("Raw Data")

subplot(3, 1, 2)
hold on
plot(alpha2_history(781, :));
title("Alpha = 0.55")

subplot(3, 1, 3)
hold on
plot(alpha1_history(781, :));
title("Alpha = 0.95")