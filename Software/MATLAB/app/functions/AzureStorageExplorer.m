function AzureStorageExplorer(varargin)
% AZURESTORAGEEXPLORER Invokes the Azure Storage Explorer
% Brings up the Azure Storage Explorer. It is possible to specify the local
% installation of the storage explorer in the configuration file.
%
% By default the MATLAB path will be searched for a configuration file called
% storagesettings.json, however an alternative filename can be provided as
% an argument to this function.

% Copyright 2020-2023 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

% Locate the path
if length(varargin) > 1
    write(logObj,'error','Too many arguments');
end

if isempty(varargin)
    configFile = which('storagesettings.json');
else
    configFile = varargin{1};
end

if exist(configFile,'file')==2
    % Read the config file
    config = jsondecode(fileread(configFile));

    if isfield(config, 'LocalPathToStorageExplorer')
        % Storage explorer is at:
        sePath = config.LocalPathToStorageExplorer;

        % Check if we are good to go
        if exist(sePath,'file')==2
            % attempt to start storage explorer
            system([config.LocalPathToStorageExplorer, ' &']);
        else
            write(logObj,'error',['Storage explorer not found at path: ', sePath]);
        end
    else
        write(logObj,'error','LocalPathToStorageExplorer not set in storagesettings.json');
    end
else
    write(logObj,'error','storagesettings.json with Storage Explorer path not found');
end %function
