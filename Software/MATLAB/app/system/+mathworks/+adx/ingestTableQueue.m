function success = ingestTableQueue(T, options)
    % ingestTableQueue Ingests a MATLAB table to an Azure Data Explorer Table
    % The table is converted to a temporary local parquet file to facilitate
    % ingestion.
    %
    % Arguments:
    %              T: A MATLAB table.
    %
    % Optional named arguments:
    %      tableName: A name for the table, if not specified the tabled will
    %                 be named ingestedTable-<UTC timestamp>
    %       database: database name, if not specified the database configured in
    %                 the json settings file will be used.
    %        cluster: Cluster name, if not specified the database configured in
    %                 the json settings file will be used.
    %    bearerToken: Bearer Token, if not specified the database configured in
    %                 the json settings file will be used.
    %

    % Copyright 2023 The MathWorks, Inc.

    arguments
        T table;
        options.tableName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.database string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.bearerToken string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    warning("ingestTableQueue is a work in progress and is not completely functional at this time & should not be used");

    parquetFile = [tempname, '.parquet'];
    parquetwrite(parquetFile, T);
    cleanup = onCleanup(@() delete(parquetFile));

    args = {"format", "parquet"};
    if isfield(options, tableName)
        args{end+1} = "tableName";
        args{end+1} = options.tableName;
    else
        N = datetime("now", "TimeZone", "UTC");
        N.Format = "yyyyMMdd'T'HHmmss";
        args{end+1} = "tableName";
        args{end+1} = "ingestedTable-" + string(N);
        fprintf("Using table name: %s\n", args{end});
    end
    
    args = mathworks.utils.addArgs(options, ["database", "cluster", "bearerToken"], args);
    success = mathworks.adx.ingestFileQueue(parquetFile, args{:});
    if ~success
        if options.verbose
            fprintf(2,'Ingestion failed\n');
        end
    end
end
