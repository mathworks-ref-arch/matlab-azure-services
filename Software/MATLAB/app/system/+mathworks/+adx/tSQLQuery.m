function [result, success, requestId, resultTables, dataSetHeader, dataSetCompletion] = tSQLQuery(query, options)
    % tSQLQuery Runs a T-SQL query
    % This is a higher-level wrapper function for KQLQuery which sets the
    % query propertyName and propertyValue to enable the tSQL syntax.
    % Input arguments and return values are as per KQLQuery.
    %
    % It assumes the query_language property is not already set, if so it will
    % be overwritten.
    %
    % See: https://learn.microsoft.com/en-us/azure/data-explorer/t-sql

    % Copyright 2023-2024 The MathWorks, Inc.

    arguments
        query string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.database string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.propertyNames (1,:) string {mustBeNonzeroLengthText}
        options.propertyValues (1,:) cell
        options.convertDynamics (1,1) logical = true
        options.nullPolicy (1,1) mathworks.adx.NullPolicy = mathworks.adx.NullPolicy.ErrorLogicalInt32Int64
        options.allowNullStrings (1,1) logical = false;
        options.verbose (1,1) logical = false;
    end

    if isfield(options, "propertyNames")
        propertyNames = options.propertyNames;
    else
        propertyNames = string.empty;
    end
    propertyNames(end+1) = "query_language";
    
    if isfield(options, "propertyValues")
        propertyValues = options.propertyValues;
    else
        propertyValues = {};
    end
    propertyValues{end+1} = "sql";

    if numel(propertyValues) ~= numel(propertyNames)
        error("adx:tSQLQuery","The number of propertyName values and propertyValue values should be equal");
    end

    args = {"propertyNames", propertyNames, "propertyValues", propertyValues};
    args = mathworks.utils.addArgs(options, ["verbose", "database", "cluster", "convertDynamics", "nullPolicy", "allowNullStrings"], args);
    [result, success, requestId, resultTables, dataSetHeader, dataSetCompletion] = mathworks.adx.KQLQuery(query, args{:});
end
