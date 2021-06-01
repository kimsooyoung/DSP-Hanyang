try
    radar1.stop();
    radar1.close();

catch me
end

clear;
close all;

%% Check Variables
% AvailablePortsName = getAvailableComPort();
% COM = AvailablePortsName(2);
COM1 = 'COM3';
FPS = 20;
% COM = serialInfo.AvailableSerialPorts(2);
CollectionH = 1/6;
SaveOnOffFlag = 1;
MaxDataLength = FPS*60*60*CollectionH;
Alpha = 0.97;
Alpha2 = 0.8;
TxPower = 3; % Default: 2, 1 ~ 3
TxCenterFreq = 4;
% 3: EU  6.0 - 8.5
% 4: KCC 7.25 - 10.20
FrameStart = 0.4; % meters. Direct Path
FrameStop = 7; % meters.
CorrectMeter = 2;


%% Init Variables
DataCursor1 = 1;
% DataCursor2 = 1;
ResetCounter1 = 0;
% ResetCounter2 = 0;
dataType = 'rf';
% Chip settings
PPS = 4*100;
DACmin = 849+75;
DACmax = 1200-75;
Iterations = 4;
SamplingFreq = 23.328; % GHz
if(TxCenterFreq==3)
    CutOff_Low = 6.0;
    CutOff_High = 8.5;
    Bandwidth = (CutOff_High - CutOff_Low); % GHz
    CenterFreq = 7.290; % GHz
elseif(TxCenterFreq==4)    
    CutOff_Low = 7.25;
    CutOff_High = 10.20;
    Bandwidth = (CutOff_High - CutOff_Low); % GHz
    CenterFreq = 8.748; % GHz
end

N    = 40;       % Order
Fc1  = CutOff_Low/(SamplingFreq/2);      % First Cutoff Frequency
Fc2  = CutOff_High/(SamplingFreq/2);     % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
% Create the window vector for the design algorithm.
win = hamming(N+1);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, [Fc1 Fc2], 'bandpass', win, flag);

%% Vital Sign Extraction Variables
DefaultWindowL_Time = 10;
VitalSignBeforeFilter = zeros(DefaultWindowL_Time*FPS,1);
%%
addpath('matlab');
addpath('include');
addpath('lib');

% Load the library
Lib = ModuleConnector.Library;
% Lib.libfunctions

% % Chip settings: Original
% PPS = 26;
% DACmin = 949;
% DACmax = 1100;
% Iterations = 56;
% FrameStart = 0; % meters.
% FrameStop = 3; % meters.

%% Using BasicRadarClassX4

radar1 = BasicRadarClassX4(COM1,FPS,dataType);

% Open radar.
radar1.open();

% Initialize radar.
radar1.init();

% Configure X4 chip.
radar1.radarInstance.x4driver_set_pulsesperstep(PPS);
radar1.radarInstance.x4driver_set_dac_min(DACmin);
radar1.radarInstance.x4driver_set_dac_max(DACmax);
radar1.radarInstance.x4driver_set_iterations(Iterations);
radar1.radarInstance.x4driver_set_tx_power(TxPower);
radar1.radarInstance.x4driver_set_tx_center_frequency(TxCenterFreq);

% Configure frame area
radar1.radarInstance.x4driver_set_frame_area(FrameStart,FrameStop);
% Read back actual set frame area
[frameStart1, frameStop1] = radar1.radarInstance.x4driver_get_frame_area();

% Start streaming and subscribe to message_data_float.
radar1.start();
%%

tstart = tic;

F1H = figure(1);
subplot(211)
B_LowPass_F1 = plot(0,0);
grid on;

fh = figure(2);
clf(fh);
subplot(211)
ph1 = plot(0);
ylabel('Normalized amplitude');
xlabel('Range [m]');
th1 = title('');
grid on;

% subplot(212)
% ph2 = plot(0);
% ylabel('Normalized amplitude');
% xlabel('Range [m]');
% th2 = title('');
% grid on;

i1 = 0;
% i2 = 0;


F2H = figure(3); % Vital Signal plot을 위한 figure
subplot(2,1,1)
VitalSign_F = plot(0,0);
axis auto

subplot(2,1,2)
VitalSign_FFT_F = plot(0,0);
xlim([0 60])
ylim([0 inf])

th2 = title(''); % Vital Signal Frequency 성분 표현
try
    
    %     while ishandle(fh)
    while(1)
        % Peek message data float
        numPackets1 = radar1.bufferSize();

        if (numPackets1 > 0)
            %% Novelda Basic
            i1 = i1+1;
            % Get frame (uses read_message_data_float)
            [frame, ctr] = radar1.GetFrameNormalized();
            frame_Raw1 = frame;
            
            if ((i1==1)&&(ResetCounter1==0))
                numBins = length(frame);
                if strcmp('bb', dataType)
                    numBins = numBins/2;
                end
                binLength = (frameStop1-frameStart1)/(numBins-1);
                rangeVec = (0:numBins-1)*binLength + frameStart1;
                ph1.XData = rangeVec;
            end
            
            switch dataType
                case 'rf'
                    ph1.YData = frame;
                    %                     ylim([-1.2 1.2]);
%                     ylim([-0.5 0.5]);
                case 'bb'
                    frame = frame(1:end/2) + 1i*frame(end/2 + 1:end);
                    ph1.YData = abs(frame);
                    %                 ph.YData = abs(frame_Raw);
%                     ylim([-0.1 2]);
            end
            
            th1.String = ['FrameNo: ' num2str(i1) ' - Length: ' num2str(length(frame)) ' - FrameCtr: ' num2str(ctr)];
            
            if mod(i1,100)==0
                disp(['Packets available: ' num2str(radar1.bufferSize())]);
            end
            
            %% 
            
            if ( (DataCursor1==1)&&(ResetCounter1==0) )
                DataLength1 = length(frame);
                DataLengthCorrected1 = round(DataLength1*CorrectMeter/(FrameStop - FrameStart));
                RawData_Ori1 = zeros(MaxDataLength,DataLengthCorrected1); 
                RawData1 = zeros(MaxDataLength,DataLengthCorrected1); 
                Hilbert_History = zeros(MaxDataLength,DataLengthCorrected1);
                
                ClockArray1 = zeros(MaxDataLength,6);
                LowPass_Clutter1 = zeros(1,DataLengthCorrected1);
                B_LowPass1 = zeros(MaxDataLength,DataLengthCorrected1);
                %% HP Search Variables
                HP = 50;
                DataCursor_ForHP = 1;
                B_Low_SaveDataN_ForHP = FPS*5;
                B_Low_Stack_ForHP = zeros(B_Low_SaveDataN_ForHP,DataLengthCorrected1);
                SumArr = zeros(1,DataLengthCorrected1);
                SquareSumArr = zeros(1,DataLengthCorrected1);
                VarArr = zeros(1,DataLengthCorrected1);
                
            end
            
            RawData_Ori1(DataCursor1,:) = frame(1:DataLengthCorrected1);
            RawData1(DataCursor1,:) = RawData_Ori1(DataCursor1,:);
            RawData1(DataCursor1,:) = RawData1(DataCursor1,:) - mean(RawData1(DataCursor1,:));      % DC Removal
            RawData1(DataCursor1,:) = conv(RawData1(DataCursor1,:),b,'same');                       % Bandpass Filtering
            
            
            LowPass_Clutter1 = Alpha .* LowPass_Clutter1 + (1-Alpha) .* RawData1(DataCursor1,:);    % Background Subtraction (Clutter Update)
            
            B_LowPass1(DataCursor1,:) = RawData1(DataCursor1,:) - LowPass_Clutter1;                 % Background Subtraction (Clutter Removal)
            
            Hilbert_temp =  abs(hilbert(B_LowPass1(DataCursor1,:)));                                                                      % Hilbert Transform & abs function
            Hilbert_History(DataCursor1,:) = Hilbert_temp;                                        % Make Hilbert History 

                %% HP Search
                SumArr = SumArr - B_Low_Stack_ForHP(DataCursor_ForHP,:);
                SquareSumArr = SquareSumArr - B_Low_Stack_ForHP(DataCursor_ForHP,:).^2;
                
                B_Low_Stack_ForHP(DataCursor_ForHP,:) = B_LowPass1(DataCursor1,:);
                SumArr = SumArr + B_Low_Stack_ForHP(DataCursor_ForHP,:);
                SquareSumArr = SquareSumArr + B_Low_Stack_ForHP(DataCursor_ForHP,:).^2;
                
                DataCursor_ForHP = DataCursor_ForHP + 1;
                    if(DataCursor_ForHP > B_Low_SaveDataN_ForHP)
                        DataCursor_ForHP = 1;
                    end
%                     
                VarArr = (SquareSumArr / B_Low_SaveDataN_ForHP) - (SumArr/B_Low_SaveDataN_ForHP).^2;  %(a^2 + b^2 + c^2)/n  - m^2     standard deviation
                [~,HP] = max(VarArr);                                                                 % find HP point using Max Function
                fprintf([num2str(HP*0.0064 + FrameStart) '\n'])                                       % print Real HP distance from radar
                
              %% Vital Sign Extraction  
            if DataCursor1 > DefaultWindowL_Time*FPS
            VitalSignBeforeFilter = B_LowPass1(DataCursor1-DefaultWindowL_Time*FPS+1:DataCursor1,HP);  % B_LowPass1에서 호흡신호 최근 10초간 뽑기
            fft_result = abs(fft(VitalSignBeforeFilter,2^12));
            [~,VitalSignFreq] = max(fft_result);                                                       % VitalSignBeforeFilter에서 fft를 통해 호흡수 추출하기, max 함수 사용
            VitalSignFreq = VitalSignFreq/2^12 * 20 * 60;                                              % 추출한 호흡신호 index를 실제 분당 호흡수로 변환하기
            set(VitalSign_F, 'XData', 1:length(VitalSignBeforeFilter), 'YData', VitalSignBeforeFilter);% set함수를 사용하여 VitalSign_F Figure에 호흡신호 실시간으로 plot 하기
            th2.String = ['Vital Signal Frequency: ' num2str(VitalSignFreq) ];                         % VitalSign_F Figure의 Title에 분당 호흡수 실시간으로 출력하기
            
            set(VitalSign_FFT_F, 'XData', 1:length(fft_result), 'YData', fft_result); % VitalSign_FFT_F에 VitalSignal의 FFT 결과 실시간으로 출력
            
            end
        %%
            
            ClockArray1(DataCursor1,:) = datenum(clock);

            FDataCursor1 = DataCursor1;
            DataCursor1 = DataCursor1 + 1;
            
            if(DataCursor1>MaxDataLength)
                if(SaveOnOffFlag==1)
                    save(datestr(now,30));
                end
                DataCursor1 = 1;
                i1= 0;
                RawData1 = zeros(MaxDataLength,DataLengthCorrected1);
                B_LowPass1 = zeros(MaxDataLength,DataLengthCorrected1);                
                ResetCounter1 = ResetCounter1+1;
            end
            
            
        end

        %%
        
        set(B_LowPass_F1, 'XData', (1:length(B_LowPass1(1,:)))/1.5625, 'YData', B_LowPass1(FDataCursor1,:))
        drawnow;
    end
    
catch me
    
    figure;
    plot(VitalSignBeforeFilter);   % Before Filtering
    hold on
    
    LPF = load('fs_20_pass_0_stop_11.mat').bpf;
    VitalSignAfterFilter = conv(VitalSignBeforeFilter, LPF); % LowPass Filtering
    plot(VitalSignAfterFilter);   % After Filtering
    
    tspent = toc(tstart);
%     framesRead = i;
    framesRead1 = i1+ResetCounter1*MaxDataLength;
    totFramesFromChip = ctr;
    FPS_est = framesRead1/tspent;
%     framesDropped = ctr-i;
    framesDropped = ctr-framesRead1;
    
    disp(['Read ' num2str(framesRead1) ' frames. A total of ' num2str(totFramesFromChip) ' were sent from chip. Frames dropped: ' num2str(framesDropped)]);
    disp(['Estimated FPS: ' num2str(FPS_est) ', should be: ' num2str(FPS)]);
    if(SaveOnOffFlag==1)
        save(datestr(now,30));
    end
    
    radar1.close();

    clear radar frame
    
end