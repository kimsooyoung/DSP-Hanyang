% This example demonstrates the use of ModuleConnector.DataRecorder to
% record the data_float message from XEP.

COMPORT = 'COM3';

% Load the library
Lib = ModuleConnector.Library;
Lib.libfunctions;

outputDir = '.';

% Create ModuleConnector instance.
mc = ModuleConnector.ModuleConnector(COMPORT);
% Get XEP interface
xep = mc.get_xep();
% Get DataRecorder
recorder = mc.get_data_recorder();

% Data types for recording.
floatData = recorder.dataRecorderInterface.DataType_FloatDataType;

% Set session id.
recorder.set_session_id('test_rec1');

% Get session id.
id = recorder.get_session_id();

% Set file split duration 30 sec.
recorder.set_file_split_duration(30);

% Set directory split duration 1 min.
recorder.set_directory_split_duration(60);

% Set basename for data_float type.
recorder.set_basename_for_data_type(floatData,'hei');

% Get basename for data_float type.
name = recorder.get_basename_for_data_type(floatData);
disp(['Basename data_float: ' name]);

% Clear basename.
recorder.clear_basename_for_data_types(floatData);

% Get basename for data_float type.
name = recorder.get_basename_for_data_type(floatData);
disp(['Basename data_float: ' name]);

% Start recording float data.
recorder.start_recording(floatData,outputDir);

% Init chip.
xep.x4driver_init();
% Enable downconversion.
xep.x4driver_set_downconversion(1);
% Start streaming with 20 FPS.
xep.x4driver_set_fps(20);

% Record 2 minutes of data.
pause(120);

% Stop recording.
recorder.stop_recording(floatData);

% Clean up.
clear x4;
clear mc;
clear dr;
Lib.unloadlib;
clear Lib;
