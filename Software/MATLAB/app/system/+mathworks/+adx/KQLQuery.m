function [result, success, requestId, resultTables, dataSetHeader, dataSetCompletion] = KQLQuery(query, options)
    % KQLQuery Runs a KQL query
    %
    % Required argument
    %   query: query to be run as a string or character vector
    %
    % Optional arguments
    %  database: Name of the the database to be used, by default a value will be
    %            taken from the settings JSON file.
    %
    %  propertyNames: Property names to be applies to the query, specified as a 
    %                 string array.
    %
    %  propertyValues: Property values that correspond the propertyNames, specified
    %                  as a cell array.
    %
    %  type: Force the type of the query, options are "query" or "command" by default
    %        the query will be examined to determine the type.
    %
    %  cluster: A non default cluster can be specified as a string or character vector.
    %
    %  bearerToken: Token used to authenticate KQL queries only, overrides JSON
    %               settings file based authentication. Provided as a text scalar.
    %
    %  convertDynamics: Logical to determine if dynamic fields are decoded or not.
    %
    %  nullPolicy: A mathworks.adx.NullPolicy enumeration to determine how
    %              null values are handled in returned results.
    %
    %  useParallel: A logical to enable the use of Parallel Computing Toolbox if
    %               available to improve performance on large queries.
    %               Default is false.  Applies to KQL queries only.
    %               See: Documentation/Performance.md for more details.
    %
    %  parallelThreshold: The number of rows above which a parpool will be started
    %                     rather than just working serially, if making a large
    %                     query or repeated queries then the overhead caused by 
    %                     the creation of a parpool should be amortized.
    %                     The default is 1000 rows.
    %
    %  verbose: A logical to enable additional output. Default is false.
    %
    %
    % Return values
    %  result: Table containing the primary result of the query or command. If the
    %          request failed the result will be a adx.control.models.ErrorResponse
    %          rather than a table.
    %
    %  success: A logical to indicate if the query succeed or not.
    %
    %  requestId: The request's ID string in ADX.
    %
    %  resultTables: Returned tables including metadata, values have not been processed
    %                into MATLAB Tables.
    %
    %  dataSetHeader: For calls that use the V2 REST API the value contains version
    %                 information and whether the call is progressive or not.
    %                 See https://learn.microsoft.com/en-us/azure/data-explorer/kusto/api/rest/response-v2#datasetheader
    %
    %  dataSetCompletion: For calls that use the V2 REST API the value indicates
    %                     if the request was cancelled or has an error and if so
    %                     error information, in general the success value and result
    %                     (adx.control.models.ErrorResponse) is simpler to work with.
    %                     See https://learn.microsoft.com/en-us/azure/data-explorer/kusto/api/rest/response-v2#datasetcompletion

    % Copyright 2023-2024 The MathWorks, Inc.

    arguments
        query string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.database string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.bearerToken string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.propertyNames (1,:) string {mustBeNonzeroLengthText}
        options.propertyValues (1,:) cell
        options.convertDynamics (1,1) logical = true
        options.nullPolicy (1,1) mathworks.adx.NullPolicy = mathworks.adx.NullPolicy.ErrorLogicalInt32Int64
        options.allowNullStrings (1,1) logical = false;
        options.customRowDecoder function_handle = function_handle.empty
        options.useParallel (1,1) logical = false
        options.parallelThreshold (1,1) int32 = 1000;
        options.verbose (1,1) logical = false;
    end

    if isfield(options, "propertyNames") && isfield(options, "propertyValues")
        if numel(options.propertyNames) ~= numel(options.propertyValues)
            error("adx:KQLQuery", "The number of propertyNames and propertyValues must match");
        else
            if options.verbose; fprintf("Applying properties\n"); end
            applyProperties = true;
        end
    else
        applyProperties = false;
    end

    request = adx.data.models.QueryRequest();
    % Set the query string
    request.csl = query;
    % Don't set the database use the default in .json config file
    if isfield(options, "database")
        request.db = options.database;
    end

    if applyProperties
        crpo = adx.data.models.ClientRequestPropertiesOptions;
        for n = 1:numel(options.propertyNames)
            if isprop(crpo, options.propertyNames(n))
                try
                    if options.verbose; fprintf("Setting property: %s\n", options.propertyNames(n)); end
                    crpo.(options.propertyNames(n)) = options.propertyValues{n};
                catch exception
                    fprintf("Assignment failure for: %s, property class: %s, value class: %s",...
                        options.propertyNames(n), class(crpo.(options.propertyNames(n))), class(options.propertyValues{n}));
                    rethrow(exception);
                end
            else
                error("adx:KQLQuery", "adx.data.models.ClientRequestPropertiesOptions does not have a property named: %s", options.propertyNames(n));
            end
        end
        crp = adx.data.models.ClientRequestProperties();
        crp.Options = crpo;
        request.requestProperties = crp;
    end

    % Create the Query object and run the request
    args = mathworks.utils.addArgs(options, "bearerToken");
    query = adx.data.api.Query(args{:});
    
    args = mathworks.utils.addArgs(options, ["verbose", "cluster"]);
    [code, runResult, response, requestId] = query.queryRun(request, args{:});
    
    dataSetCompletion = adx.data.models.DataSetCompletion.empty; % Only applies to v2 responses
    dataSetHeader = adx.data.models.DataSetHeader.empty; % Only applies to v2 responses
    resultTables = {};

    if code == matlab.net.http.StatusCode.OK
        % Convert the response to Tables
        if options.verbose; fprintf("Converting response to table(s)\n"); end

        args = {"convertDynamics", options.convertDynamics, "nullPolicy", options.nullPolicy, "verbose", options.verbose, "useParallel" options.useParallel, "parallelThreshold", options.parallelThreshold, "allowNullStrings", options.allowNullStrings};
        if isfield(options, "customRowDecoder")
            args{end+1} = "customRowDecoder";
            args{end+1} = options.customRowDecoder;
        end

        if isa(runResult, "adx.data.models.QueryV1ResponseRaw")
            resultTables = {runResult};
            [result, ~] = mathworks.internal.adx.queryV1Response2Tables(runResult, args{:});
            success = true;
        elseif isa(runResult, "adx.data.models.QueryV2ResponseRaw")
            [result, resultTables, dataSetHeader, dataSetCompletion] = mathworks.internal.adx.queryV2Response2Tables(runResult, args{:});
            success = ~dataSetCompletion.HasErrors && ~dataSetCompletion.Cancelled;
        else
            fprintf("Expected result of type: adx.data.models.QueryV1ResponseRaw or adx.data.models.QueryV2ResponseRaw, received & returning: %s\n", class(runResult));
            result = runResult;
            success = false; % This is likely a problem so fail for now
        end
    elseif isa(runResult, 'adx.control.models.ErrorResponse')
        result = runResult;
        if isprop(result, 'error') && isprop(result.error, 'message')
            fprintf('Error:\n  Code: %s\n  Query: %s\n  Message: %s\n', code, request.csl, result.error.message);
        else
            fprintf('Error:\n  Code: %s\n  Query: %s\n', code, request.csl);
        end
        success = false;
    else
        result = adx.control.models.ErrorResponse.empty;
        fprintf('Unexpected error:\n  Code: %s\n  Query: %s\n', code, request.csl);
        disp("  Response:");
        disp(response);
        success = false;
    end

    if options.verbose && ~success; fprintf("Returning success: false\n"); end
end
