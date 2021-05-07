% Add PATHs
addpath('../matlab/');
addpath('../../include/');
addpath('../../lib/');

COMPORT = 'COM3';

% Load the library
Lib = ModuleConnector.Library;
Lib.libfunctions

%% Using ModuleConnector
%
mc = ModuleConnector.ModuleConnector(COMPORT);
x2 = mc.get_x2();

frame = x2.capture_single_normalized_frame();
figure;plot(frame)

clear x2 frame
clear mc

%% Using BasicRadarClass
%
radar = BasicRadarClass(COMPORT);
radar.open();

frame = radar.GetSingleFrameNormalized();
figure;plot(frame)

radar.close();
clear radar frame

%% Using FunctionalRadarClass
%
radar = FunctionalRadarClass(COMPORT);
radar.open();

radar.killstream_sec = 5; % plot 5 seconds of data 
radar.start();

figure;plot(radar)

radar.close();
clear radar frame

Lib.unloadlib();
