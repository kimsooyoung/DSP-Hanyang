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
COM1 = 'COM5';
FPS = 20;
% COM = serialInfo.AvailableSerialPorts(2);

% Max save time (=10 min)
CollectionH = 1/6;

% Whether to Save Log
SaveOnOffFlag = 1;
MaxDataLength = FPS*60*60*CollectionH;

Alpha = 0.95;
Alpha2 = 0.55;
TxPower = 3; % Default: 2, 1 ~ 3
TxCenterFreq = 4;
% 3: EU  6.0 - 8.5 GHz
% 4: KCC 7.25 - 10.20 GHz

% Min observe meters. Consider Direct Path
FrameStart = 0.4; 
% Max observe meters.
FrameStop = 7;
CorrectMeter = 2;

%% Init Variables

% index of data. 
% Now FPS is 20, So DataCursor1 100 means data at 5 sec
DataCursor1 = 1;
% DataCursor2 = 1;
ResetCounter1 = 0;
% ResetCounter2 = 0;
dataType = 'rf';
% Chip settings
PPS = 4*100;
DACmin = 849+50;
DACmax = 1200-50;
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

%% Band Pass Filter

N    = 40;       % Order
Fc1  = CutOff_Low/(SamplingFreq/2);      % First Cutoff Frequency
Fc2  = CutOff_High/(SamplingFreq/2);     % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
% Create the window vector for the design algorithm.
win = hamming(N+1);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, [Fc1 Fc2], 'bandpass', win, flag);

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

try
    
    %     while ishandle(fh)
    while(1)
        % Peek message data float
        numPackets1 = radar1.bufferSize();

        if (numPackets1 > 0)
           %% Novelda Basic, Get Data from buffer
            i1 = i1 + 1;
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
                    % ylim([-1.2 1.2]);
                    % ylim([-0.5 0.5]);
                case 'bb'
                    frame = frame(1:end/2) + 1i*frame(end/2 + 1:end);
                    ph1.YData = abs(frame);
                    % ph.YData = abs(frame_Raw);
                    % ylim([-0.1 2]);
            end
            
            th1.String = ['FrameNo: ' num2str(i1) ' - Length: ' num2str(length(frame)) ' - FrameCtr: ' num2str(ctr)];
            
            if mod(i1,100)==0
                disp(['Packets available: ' num2str(radar1.bufferSize())]);
            end
            
           %% Actual Signal Processing in here.
            
            % First iteration Option
            if ( (DataCursor1 == 1) && (ResetCounter1 == 0) )
                ResPoint = 9;
                WatchTime = 10;
                BreathingWindow = FPS*WatchTime;
                DataLength1 = length(frame);
                DataLengthCorrected1 = round(DataLength1*CorrectMeter/(FrameStop - FrameStart)); % Maximum observed distance
                RawData_Ori1 = zeros(MaxDataLength,DataLengthCorrected1); % Original Raw Data
                RawData1 = zeros(MaxDataLength,DataLengthCorrected1); % DC Remove, Bandpass Filtered
                HilbertHistory = zeros(MaxDataLength,DataLengthCorrected1);
                DistanceHistory = zeros(MaxDataLength,1);
                
                ClockArray1 = zeros(MaxDataLength,6);
                LowPass_Clutter1 = zeros(1,DataLengthCorrected1);
                LowPass_Clutter2 = zeros(1,DataLengthCorrected1);
                B_LowPass1 = zeros(MaxDataLength,DataLengthCorrected1);
                B_LowPass2 = zeros(MaxDataLength,DataLengthCorrected1);
            end
            
            RawData_Ori1(DataCursor1,:) = frame(1:DataLengthCorrected1);
            RawData1(DataCursor1,:) = RawData_Ori1(DataCursor1,:);
            RawData1(DataCursor1,:) = RawData1(DataCursor1,:) - mean(RawData1(DataCursor1,:));
            RawData1(DataCursor1,:) = conv(RawData1(DataCursor1,:),b,'same'); % Band Pass Filter Adapted
            
            HilbertHistory(DataCursor1,:)  = abs(hilbert(RawData1(DataCursor1,:)));
            [MaxValue, MaxIndex] = max(HilbertHistory(DataCursor1,:));
            DistanceHistory(DataCursor1,:) = 0.0064 * MaxIndex;
            
            LowPass_Clutter1 = Alpha  .* LowPass_Clutter1 + (1-Alpha) .* RawData1(DataCursor1,:);
            LowPass_Clutter2 = Alpha2 .* LowPass_Clutter2 + (1-Alpha2) .* RawData1(DataCursor1,:);
            
            B_LowPass1(DataCursor1,:) = RawData1(DataCursor1,:) - LowPass_Clutter1;
            B_LowPass2(DataCursor1,:) = RawData1(DataCursor1,:) - LowPass_Clutter2;
            
            %     B_LowPass(DataCursor,:) = abs(hilbert(B_LowPass(DataCursor,:)));
            
            
            
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