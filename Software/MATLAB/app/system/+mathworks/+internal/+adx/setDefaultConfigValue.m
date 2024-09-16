function setDefaultConfigValue(field, value, options)
    % setDefaultConfigValue Sets a field in the config file
    
    % Copyright 2023 The MathWorks, Inc.

    arguments
        field string {mustBeNonzeroLengthText, mustBeTextScalar}
        value
        options.configFile string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    args = {};
    if isfield(options, 'configFile')
        args{end+1} = 'configFile';
        args{end+1} = options.configFile;
        configFile = options.configFile;
    else
        configFile = which("adx.Client.Settings.json");
    end
    if ~isfile(configFile)
        error("mathworks:internal:adx:setDefaultConfigValue","configFile field not found: %s", configFile);
    end

    config = mathworks.internal.adx.loadConfig(args{:});
    config.(field) = value;

    jsonStr = jsonencode(config, PrettyPrint=true);
    
    fid = fopen(configFile, 'w');
    if fid == -1
        error("mathworks:internal:adx:setDefaultConfigValue","Could not open configuration file: %s", configFile);
    end
    cleanup = onCleanup(@() fclose(fid));

    fprintf(fid, "%s", jsonStr);
end