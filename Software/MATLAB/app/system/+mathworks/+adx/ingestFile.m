function [success, result] = ingestFile(localFile, tableName, options)
    % ingestTableQueue Ingests a local file to Azure Data Explorer using Azure blob
    %
    % Arguments:
    %      localFile: Path to file to be ingested.
    % 
    %      tableName: Table to ingest the data to.
    %
    % Optional arguments:
    %       database: database name, if not specified the database configured in
    %                 the json settings file will be used.
    % 
    %         format: Format of the file to be ingested, if not specified the file
    %                 extension will be used.
    % 
    %       blobName: Name of the blob to upload to, if not specified a name will be
    %                 generated based on the local file.
    %
    %         cluster: Cluster name, if not specified the database configured in
    %                 the json settings file will be used.
    %
    %     bearerToken: Bearer Token, if not specified the database configured in
    %                 the json settings file will be used.
    %
    %           mode: "drop" drop the existing table if it exists before ingesting
    %                 "create" create the table if it does not exist
    %                 "add" (Default) ingest into an existing table
    %
    % Return values:
    %    success: A logical true is returned if a success message is returned.
    %
    %     result: Tabular output of the command if successful otherwise a
    %             adx.control.models.ErrorResponse
    %
    % Example:
    %    % Get filename & path for the outages.parquet file
    %    info = parquetinfo('outages.parquet');
    %    success = mathworks.adx.ingestFile(info.Filename, 'outagesTable');
    %
    %
    %                                   Table Exists
    %  -----------------------------------------------------
    %                |       True           |     False
    %  -----------------------------------------------------
    %  Mode          |                      |
    %  create        |   add                |    create, add
    %  drop          |   drop, create, add  |    create add
    %  add (default) |   add                |    error

    % Copyright 2023-2024 The MathWorks, Inc.

    arguments
        localFile string {mustBeTextScalar}
        tableName string {mustBeTextScalar}
        options.database string {mustBeTextScalar}
        options.format string {mustBeTextScalar}
        options.blobName string {mustBeTextScalar}
        options.cluster string {mustBeTextScalar}
        options.bearerToken string {mustBeTextScalar}
        options.mode string {mustBeMember(options.mode, ["drop","create","add"])} = "add"
        options.verbose (1,1) logical = true
        options.uploadViaAzureServices logical = true % For debug use only
    end

    if options.verbose; fprintf('Starting file ingestion: %s\n', localFile); end
    
    if ~isfile(localFile)
        fprintf("File not found: %s\n", localFile);
        success = false;
        result = table.empty;
        return;
    end

    if isfield(options, 'blobName')
        blobName = options.blobName;
    else
        [~, name, ext] = fileparts(localFile);
        blobName = strcat(name, ext);
        blobName = mathworks.internal.blob.sanitizeBlobName(blobName);
    end

    if isfield(options, 'database')
        database = options.database;
    else
        database = mathworks.internal.adx.getDefaultConfigValue('database');
    end
    if ~strlength(database) > 0
        fprintf("database value not set\n");
        success = false;
        result = table.empty;
        return;
    end

    if isfield(options, 'cluster')
        cluster = options.cluster;
    else
        cluster = mathworks.internal.adx.getDefaultConfigValue('cluster');
    end
    if ~strlength(cluster) > 0
        fprintf("cluster value not set\n");
        success = false;
        result = table.empty;
        return;
    end

    if options.verbose; fprintf("Checking for existence of table: %s\n", tableName); end
    tableExists = mathworks.adx.tableExists(tableName, database=database, cluster=cluster);
    if options.verbose
        if tableExists
            disp("Table found");
        else
            disp("Table not found");
        end
    end

    args = mathworks.utils.addArgs(options, ["uploadViaAzureServices", "bearerToken", "format"]);
    switch options.mode
        case "add"
            if tableExists
                [success, result] = doIngest(localFile, cluster, database, tableName, blobName, options.verbose, args{:});
            else
                fprintf("Table not found: %s, see: mathworks.adx.createTable or the mode argument to create the table prior to ingestion\n", tableName);
                success = false;
                result = table.empty;
            end
        case "drop"
            if tableExists
                if options.verbose; disp("Dropping table"); end
                dropResult = mathworks.adx.dropTable(tableName, database=database, cluster=cluster);
                if ~istable(dropResult)
                    fprintf("dropTable failed for: %s\n", tableName);
                    success = false;
                    result = table.empty;
                    return;
                end
            end
            if options.verbose; disp("Creating table"); end
            mTable = parquetread(localFile);
            if ~mathworks.adx.createTable(mTable, tableName, database=database, cluster=cluster)
                fprintf("Table creation failed: %s\n", tableName);
                success = false;
                result = table.empty;
            else
                clear("mTable");
                [success, result] = doIngest(localFile, cluster, database, tableName, blobName, options.verbose, args{:});
            end
        case "create"
            if ~tableExists
                if options.verbose; disp("Creating table"); end
                mTable = parquetread(localFile);
                if ~mathworks.adx.createTable(mTable, tableName, database=database, cluster=cluster)
                    fprintf("Table creation failed: %s\n", tableName);
                    success= false;
                    result = table.empty;
                    return;
                end
                clear("mTable");
            end
            [success, result] = doIngest(localFile, cluster, database, tableName, blobName, options.verbose, args{:});
        otherwise
            error("adx:ingestFile", "Unexpected mode value: %s", options.mode);
    end
end


function [tf, result] = doIngest(localFile, cluster, database, tableName, blobName, verbose, options)
    arguments
        localFile string {mustBeTextScalar}
        cluster string {mustBeTextScalar}
        database string {mustBeTextScalar}
        tableName string {mustBeTextScalar}
        blobName string {mustBeTextScalar}
        verbose (1,1) logical = true
        options.format string {mustBeTextScalar}
        options.bearerToken string {mustBeTextScalar}
        options.uploadViaAzureServices logical = true % For debug use only
    end

    if verbose; disp("Ingesting table"); end

    % TODO add link to supported formats
    if ~isfield(options, 'format')
        [~, ~, ext] = fileparts(localFile);
        if strlength(ext) > 0
            if startsWith(ext, ".")
                format = extractAfter(ext, ".");
            else
                format = ext;
            end
            if ~strcmpi(format, 'parquet')
                warning("adx:ingestFile", "Format type not yet validated: %s", format)
            end
        else
            error("adx:ingestFile", "Format cannot be determined from filename: %s", localFile)
        end
    else
        format = options.format;
    end
    if ~strlength(format) > 0
        error("adx:ingestFile", "format value not set")
    end

    if verbose; disp('Getting dataBearerToken'); end
    if isfield(options, 'bearerToken') && strlength(options.bearerToken) > 0
        bearerToken = options.dataBearerToken;
    else
        q = adx.data.api.Query;
        if strlength(q.dataBearerToken) > 0
            bearerToken = q.dataBearerToken;
        else
            bearerToken = mathworks.internal.adx.getDataBearerToken(database, cluster);
        end
    end

    if ~strlength(bearerToken) > 0
        error("adx:ingestFile", "dataBearerToken value not set")
    end

    if verbose; disp('Getting ingestion resources'); end
    ingestionResources = mathworks.internal.adx.getIngestionResources('bearerToken', bearerToken, 'cluster', cluster);

    % Upload file to one of the blob containers we got from Azure Data Explorer.
    % This example uses the first one, but when working with multiple blobs,
    % one should round-robin the containers in order to prevent throttling
    if verbose; disp('Uploading to blob'); end
    if options.uploadViaAzureServices
        [blobUriWithSas, ~] = mathworks.internal.blob.clientUploadToBlobContainer(ingestionResources, blobName, localFile);
    else
        % Use copyfile for write issue debug only - see g3200984, failure is expected
        [blobUriWithSas, ~] = mathworks.internal.blob.clientCopyToBlobContainer(ingestionResources, blobName, localFile);
    end

    if verbose; disp('Direct Ingest From Storage'); end
    [tf, result] = ingestFromStorage(blobUriWithSas, database, tableName, format, 'cluster', cluster, 'bearerToken', bearerToken);
end


function [tf, result] = ingestFromStorage(blobUriWithSas, database, tableName, format, options)
    % ingestFromStorage Ingestion direct from a blob
    arguments
        blobUriWithSas string {mustBeTextScalar, mustBeNonzeroLengthText}
        database string {mustBeTextScalar, mustBeNonzeroLengthText}
        tableName string {mustBeTextScalar, mustBeNonzeroLengthText}
        format string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.bearerToken string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    args = mathworks.utils.addArgs(options, ["bearerToken", "cluster"]);
    managementClient = adx.data.api.Management(args{:});

    cmdStr = sprintf(".ingest into table %s ('%s') with (format='%s')", tableName, blobUriWithSas, format);

    req = adx.data.models.ManagementRequest('db' ,database, 'csl', cmdStr);

    [code, mrResult, response] = managementClient.managementRun(req);%#ok<*ASGLU>

    if code == matlab.net.http.StatusCode.OK
        tf = true;
        result = mathworks.internal.adx.queryV1Response2Tables(mrResult, allowNullStrings=true);
    else
        if isa(mrResult, 'adx.control.models.ErrorResponse')
            mrResult.disp();
        end
        warning("adx:ingestFile:ingestFromStorage", "Error ingesting from blob storage")
        tf = false;
        result = table.empty;
    end
end