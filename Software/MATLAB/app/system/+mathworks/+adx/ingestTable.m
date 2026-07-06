function [success, result] = ingestTable(T, options)
    % ingestTable Ingests a MATLAB table to an Azure Data Explorer Table
    % The table is converted to a temporary local parquet file to facilitate
    % ingestion.
    %
    % Example:
    %   inputTable = parquetread("myfile.parquet");
    %   [success, result] =  mathworks.adx.ingestTable(inputTable, tableName="mytablename")
    %
    % Arguments:
    %              T: A MATLAB table
    %
    % Options:
    %      tableName: A name for the table, if not specified the tabled will
    %                 be named ingestedTable-<UTC timestamp>.
    %
    %       database: database name, if not specified the database configured in
    %                 the json settings file will be used.
    %
    %        cluster: Cluster name, if not specified the database configured in
    %                 the json settings file will be used.
    %
    %    bearerToken: Bearer Token, if not specified the database configured in
    %                 the json settings file will be used.
    %
    %           mode: "drop" drop an existing table with the tableName before ingesting.
    %                 "create" create the table if it does not exist.
    %                 "add" (Default) ingest into an existing table.
    %
    %        verbose: Logical to enable additional feedback, default is true.
    %
    % timeFromMicroseconds: Transform datetimes from microseconds, default: true.
    %
    %     ingestionMapping: Specify an ingest mapping as a scalar string.
    %
    %     checkForDuration: Logical to enable checking for duration types, default: true.
    %                       Disable to improve performance if know that input does
    %                       not contain columns of type duration.
    % Return values:
    %    success: A logical true is returned if the ingest was successful.
    %
    %     result: Tabular output of the command or a
    %             adx.control.models.ErrorResponse

    % Copyright 2023-2026 The MathWorks, Inc.

    arguments (Input)
        T table;
        options.tableName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.database string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.bearerToken string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.mode string {mustBeMember(options.mode, ["drop","create","add"])} = "add"
        options.verbose (1,1) logical = true
        options.uploadViaAzureServices (1,1) logical = true % For debug use only
        options.timeFromMicroseconds (1,1) logical = true
        options.ingestionMapping string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.checkForDuration (1,1) logical = true
    end
    arguments (Output)
        success (1,1) logical
        result table
    end

    success = false;
    result = table.empty;

    if options.checkForDuration
        if options.verbose
            fprintf("Checking table for duration columns...\n");
        end
        if ~checkTableForDurations(T, verbose=options.verbose)
            warning("adx:ingestTable:duration",...
                "Column of type duration cannot be ingested, consider first converting the column to use an int64 of a given time unit\n");
            return;
        end
    end

    if options.verbose; disp("Writing table to temporary parquet file"); end
    tmpParquetFile = [tempname, '.parquet'];
    parquetwrite(tmpParquetFile, T);
    cleanup = onCleanup(@() delete(tmpParquetFile));
    
    if isfield(options, 'tableName')
        tableName = options.tableName;
    else
        N = datetime("now", "TimeZone", "UTC");
        N.Format = "yyyyMMdd'T'HHmmss";
        tableName = "ingestedTable-" + string(N);
        if options.verbose
            fprintf("Using table name: %s\n", tableName);
        end
    end
    
    args = mathworks.utils.addArgs(options,...
        ["database", "cluster", "bearerToken", "mode", "verbose", "uploadViaAzureServices", ...
        "timeFromMicroseconds", "ingestionMapping", "checkForDuration"]);
    [success, result] = mathworks.adx.ingestFile(tmpParquetFile, tableName, args{:});
    if ~success
        if options.verbose
            fprintf(2,'Ingestion failed\n');
        end
    end
end


function tf = checkTableForDurations(T, options)
    % CHECKOTHERDURATIONS Check if table contains duration columns
    % Returns false if any duration columns found, true otherwise.
    arguments (Input)
        T table
        options.verbose (1,1) logical = true
    end
    arguments (Output)
        tf (1,1) logical
    end
    
    tf = true;

    if isMATLABReleaseOlderThan("R2024b")
        varTypes = string(varfun(@class, T, 'OutputFormat', 'cell'));
    else
        varTypes = T.Properties.VariableTypes;
    end

    for n = 1: numel(T.Properties.VariableNames)
        if strcmp(varTypes(n), "duration")
            if options.verbose
                fprintf("Column: %s, is of type duration, columns of type duration cannot be ingested, consider using an int64 of a given time unit\n", varTypes(n));
            end
            tf = false;
            return;
        end
    end
end