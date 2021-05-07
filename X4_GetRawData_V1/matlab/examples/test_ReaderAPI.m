% This example demonstrates the use of ModuleConnector.DataReader to
% read a record of data.

% Load the library
Lib = ModuleConnector.Library;
Lib.libfunctions;

% Name of meta file to read
metaFilename = 'c:\Novelda\Sprints\2017\WindUpBirdChronicle\RecordingsForHarald\xethru_recording_20170403_104107_JRP_liggende\xethru_recording_meta.dat';

% Create ModuleConnector instance.
mc = ModuleConnector.ModuleConnector('playback');
% Get DataReader
reader = mc.get_data_reader();

% Open recording
status = reader.open(metaFilename);

% Check if is open
ret = reader.is_open();
if ret
    disp(['Opened recording ' metaFilename]);
else
    disp(['Failed to open recording ' metaFilename]);
end

%% Get some info about the recording
% Get start epoch.
start_epoch = reader.get_start_epoch();
[~,time_string] = epoch2matlabDateTime(start_epoch);
disp(['Start epoch is ' num2str(start_epoch) ', which in human time format translates to ' time_string]);

% Get duration.
duration = reader.get_duration();
disp(['Recording duration is ' num2str(duration/1000) ' seconds.']);

% Get size
rec_size = reader.get_size();
disp(['Recording size is ' num2str(rec_size) ' bytes.']);

% Get data types
data_types = reader.get_data_types();
disp(['Recorded data types are ' num2str(data_types)]);

%% Set read filter
% Find which baseband data is recorded, if none return.
if ~isempty(find(data_types==reader.dataRecorderInterface.DataType_BasebandIqDataType))
    bb_type = reader.dataRecorderInterface.DataType_BasebandIqDataType;
elseif ~isempty(find(data_types==reader.dataRecorderInterface.DataType_BasebandApDataType))
    bb_type = reader.dataRecorderInterface.DataType_BasebandApDataType;
else
    disp('No baseband data found in recording -> rest of test not valid -> exiting');
    return;
end

status = reader.set_filter(bb_type);

% Get filter to check it's correct
data_types = reader.get_filter();
disp(['Set filter to data types ' num2str(data_types)]);

%% Read all records
i = 1;
while ~reader.at_end()
    record(i) = reader.read_record();
    i = i+1;
end

% Clean up.
clear x4;
clear mc;
clear reader;
clear recorder;
Lib.unloadlib;
clear Lib;
