function [success, result, requestId, extentId] = ingestInline(tableName, ingestData, options)
    % ingestInline Ingests limited amounts of data into Kusto directly from MATLAB
    %
    % This ingestion method is intended for exploration and prototyping.
    % Do not use it in production or high-volume scenarios.
    %
    % The destination table should exist before calling this function.
    %
    % You must have at least Table Ingestor permissions to run this command.
    %
    % Arguments
    %       tableName   Name of the table to ingest into. Type scalar text.
    %
    %      ingestData   Data to be ingested, must be of formats that are convertible
    %                   to Kusto literals and compatible with the destination table
    %                   schema. Type cell array, table, primitive variable/array.
    %
    % Optional named arguments
    %  tableExistsCheck Check if the table exists before proceeding. Type logical,
    %                   default true.
    %
    %     checkSchema   Check that the destination schema is compatible with the
    %                   ingest data. Type logical, default true.
    %
    %        database   Non default database name. Type scalar text.
    %
    %         cluster   Non default cluster name. Type scalar text.
    %
    %   propertyNames   One or more supported ingestion properties used
    %                   to control the ingestion process.
    %
    %  propertyValues   Property values that correspond the propertyNames, specified
    %                   as a cell array.
    %
    %          scopes   Non default scopes value. Type scalar text.
    %
    % convertDynamics   Logical to determine if dynamic fields are decoded or not.
    %                   Default is true.
    %
    %      nullPolicy   A mathworks.adx.NullPolicy enumeration to determine how
    %                   null values are handled in returned results.
    %
    % allowNullStrings  Logical to allow null strings in input. Kusto does not
    %                   store null strings but control command may return them.
    %                   Default is true.
    %
    %         verbose   A logical to enable additional output. Default is true.
    %
    % Return values
    %         success   A logical to indicate if the query succeed or not.
    %
    %          result   Table containing the primary result or first table of the
    %                   command response. If the request failed the result will
    %                   be a adx.control.models.ErrorResponse rather than a table.
    %
    %       requestId   The request's ID string in ADX. Type scalar string.
    %
    %        extentId   The unique identifier for the data shard that was generated
    %                   by the command. Type scalar string.
    % 
    % If table existence check and the schema compatibility check fail empty
    % result, requestId & extentId values are returned along with a logical false
    % success.
    %
    % While not intended for performance sensitive applications disabling the 
    % table existence check and the schema compatibility check where appropriate
    % using tableExistsCheck and checkSchema respectively.
    %
    % Example:
    %  localPath = fullfile(matlabroot, "toolbox", "matlab", "demos", "outages.parquet");
    %  tableName = "outages";
    %  ingestData = praquetTable(1,:);
    %  
    %  [success, result, requestId, extentId] = mathworks.adx.ingestInline(tableName, ingestData)
    %  
    %  success =
    %    logical
    %     1
    %  result =
    %    1x5 table
    %                     ExtentId                                    ItemLoaded                      Duration    HasErrors                 OperationId              
    %      ______________________________________    _____________________________________________    ________    _________    ______________________________________
    %      "8de6b799-6e12-4994-b57b-ed75e15db0a8"    "inproc:a607e293-dbdd-4f79-a1a2-a61982585adf"    00:00:00      false      "cd4184ca-0d31-4c42-a273-5f2953f76ddf"
    %  requestId = 
    %      "63bb1cea-b589-45ac-82ad-00d68ca96aeb"
    %  extentId = 
    %      "8de6b799-6e12-4994-b57b-ed75e15db0a8"
    %
    % See also:
    %   https://learn.microsoft.com/en-us/azure/data-explorer/ingestion-properties
    %   https://learn.microsoft.com/en-us/azure/data-explorer/kusto/management/data-ingestion/ingest-inline

    % Copyright 2024 The MathWorks, Inc.

    arguments
        tableName string {mustBeTextScalar, mustBeNonzeroLengthText}
        ingestData
        options.tableExistsCheck (1,1) logical = true
        options.checkSchema (1,1) logical = true
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

    if options.tableExistsCheck
        args = mathworks.utils.addArgs(options, ["database", "cluster"]);
        tableExists = mathworks.adx.tableExists(tableName, args{:});
    
        % Exit early if using set with an existing database
        if ~tableExists
            fprintf(2, "The table: %s, does not exist and so cannot be used\n", tableName);
            requestId = string.empty;
            extentId = string.empty;
            success = false;
            result = table.empty;
            return;
        end
    end


    if options.checkSchema
        args = mathworks.utils.addArgs(options, ["database", "cluster", "verbose"]);
        if ~checkDataSchemaMatch(tableName, ingestData, args{:})
            fprintf(2, "The data to be ingested does not match the schema of the destination table, or the schema could not be determined");
            requestId = string.empty;
            extentId = string.empty;
            success = false;
            result = table.empty;
            return;
        end
    end

    commandStr = ".ingest inline into table " + tableName;

    if isfield(options, "propertyNames") && numel(options.propertyNames) > 0
        commandStr = commandStr + " with(";
        for n = 1:numel(options.propertyNames)
            commandStr = commandStr + options.propertyNames(n) + "=";
            if islogical(options.propertyValues{n})
                if options.propertyValues{n}
                    commandStr = commandStr + "true";
                else
                    commandStr = commandStr + "false";
                end
            else
                commandStr = commandStr + options.propertyValues{n};
            end
            if n < numel(options.propertyNames)
                commandStr = commandStr + ",";
            end
        end
        commandStr = commandStr + ")";
    end

    commandStr = commandStr + " <| " + newline;

    commandStr = commandStr + ingestDataToString(ingestData);

    args = mathworks.utils.addArgs(options, ["database", "cluster", "scopes", "convertDynamics", "nullPolicy", "allowNullStrings", "verbose"]);
    [result, mgtCmdSuccess, requestId] = mathworks.adx.mgtCommand(commandStr, args{:});
    if mgtCmdSuccess 
        if istable(result) && ~isempty(result) && any(matches(result.Properties.VariableNames, "HasErrors")) && islogical(result.("HasErrors"))
            success = ~any(result.("HasErrors"));
        else
            success = false;
            fprintf(2, "Unexpected command result or HasErrors value\n");
        end
        if istable(result) && ~isempty(result) && any(matches(result.Properties.VariableNames, "ExtentId")) && isStringScalar(result.("ExtentId"))
            extentId = result.("ExtentId");
        else
            extentId = string.empty;
            fprintf(2, "Unexpected command result or ExtentId value\n");
        end
    else
        success = false;
        extentId = string.empty;
    end
end


function str = ingestDataToString(data)
    % ingestDataToString Convert MATLAB data to CSV format literals
    % See also: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/scalar-data-types
    arguments
        data
    end

    str = "";
    for n = 1:height(data)
        row = "";
        for m = 1:width(data)
            if iscell(data) || istable(data)
                row = row + mathworks.internal.adx.toKustoLiteral(data{n,m});
            else
                row = row + mathworks.internal.adx.toKustoLiteral(data(n,m));
            end
            if m ~= width(data)
                row = row + ", ";
            end
        end
        if n ~= height(data)
            str = str + row + newline;
        else
            str = str + row;
        end
    end
end


function tf = checkDataSchemaMatch(tableName, ingestData, options)
    arguments
        tableName string {mustBeTextScalar, mustBeNonzeroLengthText}
        ingestData
        options.verbose (1,1) logical = true
        options.allowDynamic (1,1) logical = true
        options.database string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    args = {"JSONFormat", false, "verbose", false};
    args = mathworks.utils.addArgs(options, ["database", "cluster"], args);
    [kustoSchema, success, requestId] = mathworks.internal.adx.getTableSchema(tableName, args{:});

    if ~success
        fprintf(2, "Failed to get schema for table: %s, requestId: %s", tableName, requestId);
        tf = false;
        return;
    end

    [kustoColumnNames, kustoTypes] = mathworks.internal.adx.kustoSchemaToNamesAndTypes(kustoSchema, JSONFormat=false, verbose=options.verbose);

    if istable(ingestData)
        matlabTypes = varfun(@class, ingestData, 'OutputFormat', 'cell');
        if iscellstr(matlabTypes) %#ok<ISCLSTR>
            matlabTypes = string(matlabTypes);
        else
            error("adx:ingestInline:checkDataSchemaMatch", "Expected MATLAB table types to be a cell array of character vectors");
        end
        tf = isMATLABDataConvertible(matlabTypes, kustoTypes, columnNames=kustoColumnNames, allowDynamic=options.allowDynamic, verbose=options.verbose);
    elseif iscell(ingestData)
        matlabTypes = "";
        for n = 1:width(ingestData)
            matlabTypes(end+1) = string(class(ingestData{n})); %#ok<AGROW>
        end
        tf = isMATLABDataConvertible(matlabTypes, kustoTypes, columnNames=kustoColumnNames, allowDynamic=options.allowDynamic, verbose=options.verbose);
    else
        typeStr = string(class(ingestData));
        for n = 1:width(ingestData)
            matlabTypes(end+1) = typeStr; %#ok<AGROW>
        end
        tf = isMATLABDataConvertible(matlabTypes, kustoTypes, columnNames=kustoColumnNames, allowDynamic=options.allowDynamic, verbose=options.verbose);
    end
end


function tf = isMATLABDataConvertible(matlabTypes, kustoTypes, options)
    arguments
        matlabTypes string {mustBeNonzeroLengthText}
        kustoTypes string {mustBeNonzeroLengthText}
        options.columnNames string {mustBeNonzeroLengthText}
        options.allowDynamic (1,1) logical = true
        options.verbose (1,1) logical = true
    end

    if numel(kustoTypes) ~= numel(matlabTypes)
        error("adx:ingestInline:isMATLABDataConvertible", "The width of the MATLAB table: %d, does not match that of the Kusto table: %d", numel(matlabTypes), numel(kustoSchema));
    end

    tf = true;
    for n = 1:numel(kustoTypes)
        if ~mathworks.internal.adx.isMappableMATLABToKusto(matlabTypes(n), kustoTypes(n), allowDynamic=options.allowDynamic)
            if options.verbose
                if isfield(options, "columnNames")
                    fprintf(2, "Data not convertible MATLAB, type: %s, Kusto schema type: %s, column number: %d, column name: %s\n",...
                        matlabTypes(n), kustoTypes(n), n, options.columnNames(n));
                else
                    fprintf(2, "Data not convertible MATLAB, type: %s, Kusto schema type: %s, column number: %d\n",...
                        matlabTypes(n), kustoTypes(n), n);
                end
                tf = false;
            else
                tf = false;
                break;
            end
        end
    end
end
