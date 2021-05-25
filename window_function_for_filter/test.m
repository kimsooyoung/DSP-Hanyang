clc;clear;

% Define Time Range
t = -5:0.01:5;

% T0: Signal Cycle / T1: Non-zero time in T0
T0 = 4;
T1 = 1;
duty_cycle = 2 * T1 / T0;

% Assign Various N Values
N = [3, 10, 25, 80, 150, 500];

% for n=1:6
%     subplot(3,2,n),plot(t,getPlot(N(n), t, T0, T1));axis([-5 5 -1 1.5]);
%     xlabel('t'), ylabel('x(t)');title(['N=',int2str(N(n))]);grid;hold on;
% end


plot(t,getPlot(N(6), t, T0, T1));axis([-5 5 -1 1.5]);


% Assign analysis_equation
function anal_equ = getAnalysisEquation(k, duty_cycle)
    anal_equ = duty_cycle * sinc(duty_cycle * k);
end

% Assign basis function
function basis_func = getBasisFunction(k, t, T0)
    w0 = (2 * pi) / T0;
    basis_func = cos(k * w0 * t);
end

% Multiply two above two functions and do summation according to value k
function plt = getPlot(N, t, T0, T1)
    plt=0;
    duty_cycle = 2 * T1 / T0;
    w0 = (2 * pi) / T0;
    for k=-N:N
        plt = plt + getAnalysisEquation( k, duty_cycle ) * getBasisFunction( k, t, T0 );
    end
end
