function settings = loadConfigurationSettings(configFile)
% LOADCONFIGURATIONSETTINGS Method to read configuration settings from a file
% By default the file is named settings.json or an alternative name can be
% as an specified argument. JSON values must be compatible with MATLAB JSON
% conversion rules. See jsondecode() help for details. A MATLAB struct is
% returned.

% Copyright 2020-2021 The MathWorks, Inc.

if ischar(configFile) || isStringScalar(configFile)
    configFile = char(configFile);
else
    logObj = Logger.getLogger();
    write(logObj,'error','Unexpected argument of type character vector or scalar string');
end

if exist(configFile, 'file') == 2
    settings = jsondecode(fileread(configFile));
else
    logObj = Logger.getLogger();
    write(logObj,'error',['Configuration file not found: ', strrep(configFile,'\','\\')]);
end

end
