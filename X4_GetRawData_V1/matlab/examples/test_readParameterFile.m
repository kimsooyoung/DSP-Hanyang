% This example demonstrates the use of ModuleConnector.XEPs file API to
% read and write files to module flash storage.


% Load the library
Lib = ModuleConnector.Library;
Lib.libfunctions;

COMPORT = 'COM4';

mc = ModuleConnector.ModuleConnector(COMPORT);
xep = mc.get_xep();

% Search for parfile by type
parfileType = ModuleConnector.XEP.XTFILE_TYPE_PARFILE;
fileIDs = xep.search_for_file_by_type(parfileType);

if isempty(fileIDs)
    disp('No parameter file found in module flash storage.');
else
    % Read and display first parfile.
    parfileData = xep.get_file(parfileType,fileIDs(1),0);
    
    % Display content of parfile.
    disp('Parfile contents:');
    disp(native2unicode(parfileData)');
end


% Clean up.
clear xep;
clear mc;
Lib.unloadlib;
clear Lib;
