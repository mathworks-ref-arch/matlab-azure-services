function settings = loadConfigurationSettings(configFile)
    % LOADCONFIGURATIONSETTINGS Method to read a JSON configuration settings from a file
    % The file name must be as a specified argument.
    % JSON values must be compatible with MATLAB JSON conversion rules.
    % See jsondecode() help for details. A MATLAB struct is returned.
    % Field names are case sensitive.

    % Copyright 2020-2023 The MathWorks, Inc.

    if ischar(configFile) || isStringScalar(configFile)
        configFile = char(configFile);
    else
        logObj = Logger.getLogger();
        write(logObj,'error','Unexpected argument of type character vector or scalar string');
    end

    if exist(configFile, 'file') == 2
        settings = jsondecode(fileread(configFile));
        if isfield(settings, 'ManagedIdentityClientId')
            write(logObj,'error',['ManagedIdentityClientId field should be renamed to ClientId in: ', configFile]);
        end
        if isfield(settings, 'pemCertificate')
            write(logObj,'error',['pemCertificate field should be renamed to PemCertificate in: ', configFile]);
        end
    else
        logObj = Logger.getLogger();
        write(logObj,'error',['Configuration file not found: ', strrep(configFile,'\','\\')]);
    end
end
