function tf = validateConfig(config)
    % VALIDATECONFIG Sanity checks configuration settings
    
    % Copyright 2023 The MathWorks, Inc.

    arguments
        config struct
    end

    tf = true;

    % TODO Add more config sanity checks
    if isfield(config, 'cluster')
        if ~(startsWith(config.cluster, 'https://'))
            warning("mathworks:internal:adx:validateConfig", 'Expected cluster field to start with https:// - %s', config.cluster);
            tf = false;
        end
    end
end

