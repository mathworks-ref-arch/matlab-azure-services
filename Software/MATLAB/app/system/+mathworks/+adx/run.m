function [result, success, requestId, resultTables, dataSetHeader, dataSetCompletion] = run(query, options)
    % run Runs a KQL query or management command
    % This ia a high-level interface to simplify running most queries.
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
    %  scopes: For commands scopes can be specified as a string array.
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
    %  customRowDecoder: A function handle to a function that will be called to decode
    %                    Primary Result table JSON rows instead of the default decoder.
    %                    See: Documentation/Performance.md for more details.
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
    % verbose: A logical to enable additional output.
    %
    %
    % Return values
    %  result: Table containing the primary result of the query or command. If the
    %          request failed the result will be a adx.control.models.ErrorResponse
    %          rather than a table.
    %
    %  success: A boolean to indicate if the query succeed or not.
    %
    %  requestId: The request's ID string in ADX
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
    %
    % Example:
    %    [result, success] = mathworks.adx.run('print mycol="Hello World"')

    % Copyright 2024 The MathWorks, Inc.

    arguments
        query string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.database string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.propertyNames (1,:) string {mustBeNonzeroLengthText}
        options.propertyValues (1,:) cell
        options.type string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.scopes string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.bearerToken string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.convertDynamics  (1,1) logical = true
        options.nullPolicy (1,1) mathworks.adx.NullPolicy = mathworks.adx.NullPolicy.ErrorLogicalInt32Int64
        options.allowNullStrings (1,1)
        options.customRowDecoder function_handle = function_handle.empty
        options.useParallel (1,1) logical = false
        options.parallelThreshold (1,1) int32 = 1000;
        options.verbose (1,1) logical = false
    end

    % Clean up any white space
    query = strip(query);

    if isfield(options, "type")
        if strcmpi(options.type, "query")
            type = "query";
            allowNullStrings = false;
        elseif strcmpi(options.type, "command")
            type = "command";
            allowNullStrings = true;
        else
            error("adx:run", "Invalid type value, expecting query or command found: %s", options.type);
        end
    else
        if startsWith(query, ".")
            if startsWith(query, ".show")
                type = "query";
                allowNullStrings = true;
            else
                type = "command";
                allowNullStrings = true;
            end
        else
            type = "query";
            allowNullStrings = false;
        end
    end

    args = mathworks.utils.addArgs(options, ["database", "propertyNames", "propertyValues", "verbose", "convertDynamics", "nullPolicy", "cluster"]);
    args{end+1} = "allowNullStrings";
    if isfield(options, "allowNullStrings")
        args{end+1} = options.allowNullStrings;
    else
        args{end+1} = allowNullStrings;
    end
    
    if strcmp(type, "query")
        args = mathworks.utils.addArgs(options, ["bearerToken", "customRowDecoder", "useParallel", "parallelThreshold"], args);
        [result, success, requestId, resultTables, dataSetHeader, dataSetCompletion] = mathworks.adx.KQLQuery(query, args{:});
    elseif strcmp(type, "command")
        args = mathworks.utils.addArgs(options, "scopes", args);
        % Values don't apply for management/v1 responses
        resultTables = {};
        dataSetHeader = adx.data.models.DataSetHeader.empty;
        dataSetCompletion = adx.data.models.DataSetCompletion.empty;

        [result, success, requestId] = mathworks.adx.mgtCommand(query, args{:});
    else
        error("adx:run", "Invalid type value, expecting query or command found: %s", type);
    end

    % If the result is a single table, mostly should be extract it from
    % the cell array
    if iscell(result) && isscalar(result) && istable(result{1})
        result = result{1};
    end
end