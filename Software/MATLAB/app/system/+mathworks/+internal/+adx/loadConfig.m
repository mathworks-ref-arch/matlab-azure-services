function config = loadConfig(options)
    % LOADCONFIG Reads a config file if it exists
    %
    % Optional argument
    %   configFile: Path to JSON settings

    % Copyright 2023 The MathWorks, Inc.

    arguments
        options.configFile string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    if isfield(options,"configFile")
        configFile = options.configFile;
    else
        configFile = which("adx.Client.Settings.json");
    end
    if ~isfile(configFile)
        error("mathworks:internal:adx:loadConfig","configFile field not found: %s", configFile);
    end

    try
        config = jsondecode(fileread(configFile));
    catch ME
        error("mathworks:internal:adx:loadConfig","Error decoding JSON file: %s, check JSON syntax\n  Message: %s", configFile, ME.message);
    end
    
    mathworks.internal.adx.validateConfig(config);
end