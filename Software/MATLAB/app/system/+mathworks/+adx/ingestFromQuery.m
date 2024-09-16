function [success, result, requestId] = ingestFromQuery(command, tableName, queryOrCommand, options)
    % ingestFromQuery Ingest data using the result of a command or query
    %
    % This ingestion method is intended for exploration and prototyping.
    % Do not use it in production or high-volume scenarios.
    %
    %   Command           If table exists                 If table doesn't exist
    %   -------------------------------------------------------------------------------------------
    %   set              The command fails               The table is created and data is ingested
    %   append           Data is appended to the table   The command fails
    %   set-or-append    Data is appended to the table   The table is created and data is ingested
    %   set-or-replace   Data replaces the data          The table is created and data is ingested
    %                    in the table
    %
    % Arguments
    %         command   One of: set, append, set-or-append or set-or-replace.
    %                   Type scalar text.
    %
    %       tableName   Name of the table to ingest into. Type scalar text.
    %
    %  queryOrCommand   Command or query to append to produce the dta to ingest.
    %                   Type scalar text.
    %
    % Optional named arguments
    %           async   Logical to indicate if async mode should be used or not.
    %                   Default is false.
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
    % See also:
    %   https://learn.microsoft.com/en-us/azure/data-explorer/ingestion-properties
    %   https://learn.microsoft.com/en-us/azure/data-explorer/kusto/management/data-ingestion/ingest-from-query

    % Copyright 2024 The MathWorks, Inc.

    arguments
        command string {mustBeMember(command, {'set', 'append', 'set-or-append', 'set-or-replace'})}
        tableName string {mustBeTextScalar, mustBeNonzeroLengthText}
        queryOrCommand string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.async (1,1) logical = false
        options.database string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.propertyNames (1,:) string {mustBeNonzeroLengthText}
        options.propertyValues (1,:) cell
        options.scopes string
        options.convertDynamics (1,1) logical = true
        options.nullPolicy (1,1) mathworks.adx.NullPolicy = mathworks.adx.NullPolicy.ErrorLogicalInt32Int64
        options.allowNullStrings (1,1) logical = true
        options.verbose (1,1) logical = true
    end
    
    args = mathworks.utils.addArgs(options, ["database", "cluster"]);
    tableExists = mathworks.adx.tableExists(tableName, args{:});

    % Exit early if using set with an existing database
    if tableExists && strcmp(command, "set")
        if options.verbose
            fprintf("The table: %s, already exists hence the set command cannot be used\n", tableName);
        end
        requestId = "";
        success = false;
        result = table.empty;
        return;
    end

    % Exit early if there is no table to append to
    if ~tableExists && strcmp(command, "append")
        if options.verbose
            fprintf("The table: %s, does not exist hence the append command cannot be used\n", tableName);
        end
        requestId = "";
        success = false;
        result = table.empty;
        return;
    end

    if ~tableExists && (strcmp(command, "set-or-append") || strcmp(command, "set-or-replace"))
        if options.verbose
            fprintf("The table: %s, does not exist and will be created\n", tableName);
        end
    end

    if tableExists && strcmp(command, "set-or-replace")
        if options.verbose
            fprintf("The data in table: %s, will be replaced\n", tableName);
        end
    end

    commandStr = command + " ";
    if options.async
        commandStr = commandStr + "async ";
    end
    commandStr = commandStr + tableName + " ";

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

    commandStr = commandStr + " <| " + queryOrCommand;

    args = mathworks.utils.addArgs(options, ["database", "cluster", "scopes", "convertDynamics", "nullPolicy", "allowNullStrings", "verbose"]);
    [result, success, requestId] = mathworks.adx.mgtCommand(commandStr, args{:});
end
