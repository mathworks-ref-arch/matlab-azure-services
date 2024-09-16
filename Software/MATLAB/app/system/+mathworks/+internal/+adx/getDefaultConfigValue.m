function value = getDefaultConfigValue(field, options)
    % getDefaultConfigValue Reads a field from the config file
    % A string is returned.
    
    % Copyright 2023 The MathWorks, Inc.

    arguments
        field string {mustBeNonzeroLengthText, mustBeTextScalar}
        options.configFile string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    args = {};
    if isfield(options, 'configFile')
        args{end+1} = "configFile";
        args{end+1} = options.configFile;
    end

    config = mathworks.internal.adx.loadConfig(args{:});

    if ~isfield(config, field)
        value = string.empty;
    else
        value = string(config.(field));
    end
end