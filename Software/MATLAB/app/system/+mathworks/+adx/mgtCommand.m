function [result, success, requestId] = mgtCommand(command, options)
    % mgtCommand Runs a management command
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
    %  convertDynamics: Logical to determine if dynamic fields are decoded or not.
    %
    %  nullPolicy: A mathworks.adx.NullPolicy enumeration to determine how
    %              null values are handled in returned results.
    %
    %  verbose: A logical to enable additional output.
    %
    % Return values
    %  result: Table containing the primary result of the query or command. If the
    %          request failed the result will be a adx.control.models.ErrorResponse
    %          rather than a table.
    %
    %  success: A logical to indicate if the query succeed or not.
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
    %                     if the request was canceled or has an error and if so
    %                     error information, in general the success value and result
    %                     (adx.control.models.ErrorResponse) is simpler to work with.
    %                     See https://learn.microsoft.com/en-us/azure/data-explorer/kusto/api/rest/response-v2#datasetcompletion

    % Copyright 2024 The MathWorks, Inc.

    arguments
        command string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.database string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.propertyNames (1,:) string {mustBeNonzeroLengthText}
        options.propertyValues (1,:) cell
        options.scopes string
        options.convertDynamics (1,1) logical = true
        options.nullPolicy (1,1) mathworks.adx.NullPolicy = mathworks.adx.NullPolicy.ErrorLogicalInt32Int64
        options.allowNullStrings (1,1) logical = true
        options.verbose (1,1) logical = false
    end

    if isfield(options, "propertyNames") && isfield(options, "propertyValues")
        if numel(options.propertyNames) ~= numel(options.propertyValues)
            error("adx:mgtCommand", "The number of propertyNames and propertyValues must match");
        else
            if options.verbose; fprintf("Applying properties\n"); end
            applyProperties = true;
        end
    else
        applyProperties = false;
    end

    request = adx.data.models.ManagementRequest;
    % Set the command string
    request.csl = command;
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
                error("adx:mgtCommand", "adx.data.models.ClientRequestPropertiesOptions does not have a property named: %s", options.propertyNames(n));
            end
        end
        crp = adx.data.models.ClientRequestProperties();
        crp.Options = crpo;
        request.requestProperties = crp;
    end

    args = mathworks.utils.addArgs(options, "scopes");
    mgt = adx.data.api.Management(args{:});

    args = mathworks.utils.addArgs(options, ["verbose", "cluster"]);
    [code, runResult, response, requestId] = mgt.managementRun(request, args{:});

    success = false;
    if code == matlab.net.http.StatusCode.OK
        success = true;
        % Convert the response to Tables
        if options.verbose; fprintf("Converting response to table(s)\n"); end
        if isa(runResult, 'adx.data.models.QueryV1ResponseRaw')
            result = mathworks.internal.adx.queryV1Response2Tables(runResult, convertDynamics=options.convertDynamics, nullPolicy=options.nullPolicy, allowNullStrings=options.allowNullStrings);
        else
            fprintf("Expected result of type: adx.data.models.QueryV1ResponseRaw, received & returning: %s\n", class(runResult));
            result = runResult;
        end
    elseif isa(runResult, 'adx.control.models.ErrorResponse')
        result = runResult;
        if isprop(result, 'error') && isprop(result.error, 'message')
            fprintf('Error:\n  Code: %s\n  Command: %s\n  Message: %s\n', code, request.csl, result.error.message);
        else
            fprintf('Error:\n  Code: %s\n  Command: %s\n', code, request.csl);
        end
    else
        result = adx.control.models.ErrorResponse.empty;
        fprintf('Unexpected error:\n  Code: %s\n  Command: %s\n', code, request.csl);
        disp("  Response:");
        disp(response);
    end
end