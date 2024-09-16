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
    %                 be named ingestedTable-<UTC timestamp>
    %       database: database name, if not specified the database configured in
    %                 the json settings file will be used.
    %        cluster: Cluster name, if not specified the database configured in
    %                 the json settings file will be used.
    %    bearerToken: Bearer Token, if not specified the database configured in
    %                 the json settings file will be used.
    %           mode: "drop" drop an existing table with the tableName before ingesting
    %                 "create" create the table if it does not exist
    %                 "add" (Default) ingest into an existing table
    %        verbose: Logical to enable additional feedback, default is true

    % Copyright 2023-2024 The MathWorks, Inc.

    arguments
        T table;
        options.tableName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.database string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.bearerToken string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.mode string {mustBeMember(options.mode, ["drop","create","add"])} = "add"
        options.verbose (1,1) logical = true
    end

    if options.verbose; disp("Writing table to temporary parquet file"); end
    parquetFile = [tempname, '.parquet'];
    parquetwrite(parquetFile, T);
    cleanup = onCleanup(@() delete(parquetFile));
    
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
    
    args = {"mode", options.mode, "verbose" options.verbose};
    args = mathworks.utils.addArgs(options, ["database", "cluster", "bearerToken"], args);

    [success, result] = mathworks.adx.ingestFile(parquetFile, tableName, args{:});
    if ~success
        if options.verbose
            fprintf(2,'Ingestion failed\n');
        end
    end
end
