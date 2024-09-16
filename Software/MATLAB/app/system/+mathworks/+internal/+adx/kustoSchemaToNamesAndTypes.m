function [names, types] = kustoSchemaToNamesAndTypes(kustoSchema, options)
    % kustoSchemaToNamesAndTypes Splits a Kusto schema into string arrays of column names and types
    
    % Copyright 2024 The MathWorks, Inc.

    arguments
        kustoSchema string {mustBeNonzeroLengthText}
        options.JSONFormat (1,1) logical = false
        options.verbose (1,1) logical = true
    end

    if options.JSONFormat
        error("adx:kustoSchemaToNamesAndTypes", "JSON format Schemas are not currently supported");
    end

    names = string.empty;
    types = string.empty;

    pairs = split(kustoSchema, ",");
    for n = 1:numel(pairs)
        pair = split(pairs(n), ":");
        if numel(pair) ~= 2
            error("adx:kustoSchemaToNamesAndTypes", "Expected field to contain a ':' separated value pair: %s",pairs(n));
        end
        names(end+1) = pair(1); %#ok<AGROW>
        types(end+1) = pair(2); %#ok<AGROW>
    end
end