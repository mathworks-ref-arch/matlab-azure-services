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
    %        cluster: Cluster name, if not specified the database configured in
    %                 the json settings file will be used.
    %
    %    bearerToken: Bearer Token, if not specified the database configured in
    %                 the json settings file will be used.
    %
    %           mode: "drop" drop the existing table if it exists before ingesting.
    %                 "create" create the table if it does not exist.
    %                 "add" (Default) ingest into an existing table.
    %
    %        verbose: Display additional output, default: true.
    %
    % uploadViaAzureServices: Logical to enable uploading via Azure services, default: true.
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
    %
    % Example:
    %    % Get filename & full path for the outages.parquet file
    %    info = parquetinfo('outages.parquet');
    %    [success, result] = mathworks.adx.ingestFile(info.Filename, 'outagesTable');
    %
    %
    %  Table mode behaviors                    
    %  -----------------------------------------------------
    %                |                Table Exists   
    %                ---------------------------------------    
    %  Mode          |       True           |     False
    %  -----------------------------------------------------
    %  create        |   add                |    create, add
    %  drop          |   drop, create, add  |    create, add
    %  add (default) |   add                |    error

    % Copyright 2023-2026 The MathWorks, Inc.

    arguments (Input)
        localFile string {mustBeFile}
        tableName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.database string {mustBeTextScalar} = mathworks.internal.adx.getDefaultConfigValue('database')
        options.format string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.blobName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.cluster string {mustBeTextScalar} = mathworks.internal.adx.getDefaultConfigValue('cluster')
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

    if options.verbose; fprintf("Starting file ingestion: %s\n", localFile); end
 
    if isfield(options, "blobName")
        blobName = options.blobName;
    else
        [~, name, ext] = fileparts(localFile);
        blobName = mathworks.internal.blob.sanitizeBlobName(strcat(name, ext));
    end

    if isfield(options, "format")
        format = options.format;
    else
        format = getFormat(localFile);
    end

    if strlength(options.database) == 0
        fprintf("database value not set\n");
        return;
    else
        database = options.database;
    end

    if strlength(options.cluster) == 0
        fprintf("cluster value not set\n");
        return;
    else
        cluster = options.cluster;
    end

    if isfield(options, "bearerToken")
        bearerToken = options.bearerToken;
    else
        bearerToken = getBearerToken(database, cluster);
    end
    
    if options.checkForDuration
        if ~checkForDuration(localFile, format, verbose=options.verbose)
            warning("adx:ingestFile:duration",...
            "Column of type duration cannot be ingested, consider first converting the column to use an int64 of a given time unit\n");
            return;
        end
    end

    if options.verbose; fprintf("Checking for existence of table: %s... ", tableName); end
    tableExists = mathworks.adx.tableExists(tableName, database=database, cluster=cluster);
    if options.verbose
        if tableExists
            fprintf("found\n");
        else
            fprintf("not found\n");
        end
    end
  
    switch lower(options.mode)
        case "add"
            if ~tableExists
                fprintf("Table not found: %s, cannot use 'add' mode, see: mathworks.adx.createTable or the mode argument to create the table prior to ingestion\n", tableName);
                return;
            end

        case "drop"
            if tableExists
                [dropSuccess, dropResult] = doDropTable(tableName, database, cluster, verbose=options.verbose);
                if ~dropSuccess
                    fprintf("Table deletion failed: %s, cannot proceed with 'drop' mode\n", tableName);
                    return;
                end
            end

        case "create"
            % No Op, proceed to doCreateAndIngest
            
        otherwise
            error("adx:ingestFile", "Unexpected mode value: %s", options.mode);
    end

    args = mathworks.utils.addArgs(options, ["uploadViaAzureServices", "timeFromMicroseconds", "ingestionMapping", "verbose"]);
    [success, result] = doCreateAndIngest(localFile, tableName, format, cluster, database, blobName, bearerToken, args{:});
end


function tf = checkForDuration(localFile, format, options)
    % CHECKFORDURATION Check if table contains duration columns
    % Returns false if any duration columns found, true otherwise.
    arguments (Input)
        localFile {mustBeFile}
        format string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end
    arguments (Output)
        tf (1,1) logical
    end

    if options.verbose
        fprintf("Checking %s file for duration columns...\n", format);
    end

    if strcmpi(format, "parquet")
        tf = checkForParquetDurations(localFile, verbose=options.verbose);
    else
        try
            T = readTable(localFile);
        catch
            error("adx:ingestFile:checkForDuration:readTable", "Cannot read table from file: %s, format: %s", localFile, format);
        end
        tf = checkOtherDurations(T, verbose=options.verbose);
    end
end


function [success, result] = doCreateAndIngest(localFile, tableName, format, cluster, database, blobName, bearerToken, options)
    % DOCREATEANDINGEST Create table and ingest file into ADX
    % Assumes a input does not contain durations.
    arguments (Input)
        localFile {mustBeFile}
        tableName string {mustBeTextScalar, mustBeNonzeroLengthText}
        format string {mustBeTextScalar, mustBeNonzeroLengthText}
        cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
        database string {mustBeTextScalar, mustBeNonzeroLengthText}
        blobName string {mustBeTextScalar, mustBeNonzeroLengthText}
        bearerToken string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.uploadViaAzureServices (1,1) logical = true % For debug use only
        options.timeFromMicroseconds (1,1) logical = true
        options.ingestionMapping string {mustBeTextScalar, mustBeNonzeroLengthText} 
        options.verbose (1,1) logical = true
    end
    arguments (Output)
        success (1,1) logical
        result table
    end

    success = false;
    result = table.empty;

    % Previously checked for durations
    if strcmp(format, "parquet")
        T = parquetread(localFile);
    else
        try
            T = readTable(localFile);
        catch
            error("adx:ingestFile:doCreateAndIngest:readTable", "Cannot read table from file: %s, format: %s", localFile, format);
        end
    end

    if options.verbose; disp('Getting ingestion resources'); end
    ingestionResources = mathworks.internal.adx.getIngestionResources('bearerToken', bearerToken, 'cluster', cluster);

    % Upload file to one of the blob containers we got from Azure Data Explorer.
    % This example uses the first one, but when working with multiple blobs,
    % one should round-robin the containers in order to prevent throttling
    if options.verbose; disp('Uploading file to blob storage'); end
    if options.uploadViaAzureServices
        [blobUriWithSas, ~] = mathworks.internal.blob.clientUploadToBlobContainer(ingestionResources, blobName, localFile);
    else
        % Use copyfile for write issue debug only - see g3200984, failure is expected
        [blobUriWithSas, ~] = mathworks.internal.blob.clientCopyToBlobContainer(ingestionResources, blobName, localFile);
    end

    managementClient = adx.data.api.Management(bearerToken=bearerToken, cluster=cluster);

    if isfield(options, "ingestionMapping")
        ingestionMapping = options.ingestionMapping;
    else
        if isempty(T)
            ingestionMapping = "";
        else
            if isMATLABReleaseOlderThan("R2024b")
                varTypes = string(varfun(@class, T, 'OutputFormat', 'cell'));
            else
                varTypes = T.Properties.VariableTypes;
            end
            ingestionMapping = buildIngestMapping(varTypes, T.Properties.VariableNames, options.timeFromMicroseconds);
        end
    end

    if options.verbose; disp('Building ingest command'); end
    cmdStr = sprintf(".ingest into table %s ('%s') with (", tableName, blobUriWithSas);
    cmdStr = cmdStr + newline + sprintf("format='%s',\n", format);
    cmdStr = cmdStr + ingestionMapping;
    cmdStr = cmdStr + ")";

    if options.verbose; disp('Ingest command:'); disp(cmdStr); end

    req = adx.data.models.ManagementRequest('db' ,database, 'csl', cmdStr);

    if options.verbose; disp('Ingesting From Blob storage'); end
    [code, mgtRunResult, response] = managementClient.managementRun(req); %#ok<*ASGLU>

    if code == matlab.net.http.StatusCode.OK
        result = mathworks.internal.adx.queryV1Response2Tables(mgtRunResult, allowNullStrings=true);
        assert(height(result) == 1);
        assert(any(contains(result.Properties.VariableNames, 'HasErrors')));
        success = ~result.HasErrors(1);
    else
        if isa(mgtRunResult, 'adx.control.models.ErrorResponse')
            mgtRunResult.disp();
        end
        warning("adx:ingestFile:ingestFromStorage", "Error ingesting from blob storage")
    end
end


function tf = checkForParquetDurations(localFile, options)
    % CHECKFORPARQUETDURATIONS Check if parquet file contains duration columns
    % Returns false if any duration columns found, true otherwise.
    arguments (Input)
        localFile {mustBeFile}
        options.verbose (1,1) logical = true
    end
    arguments (Output)
        tf (1,1) logical
    end

    tf = true;
    pInfo = parquetinfo(localFile);
    for n = 1:length(pInfo.VariableNames)
        if strcmp(pInfo.VariableTypes(n), "duration")
            if options.verbose
                fprintf("Column: %s, is of type duration, parquet columns of type duration cannot be ingested, consider using an int64 of a given time unit\n", pInfo.VariableNames(n));
            end
            tf = false;
            return;
        end
    end
end


function tf = checkOtherDurations(T, options)
    % CHECKOTHERDURATIONS Check if table contains duration columns
    % Returns false if any duration columns found, true otherwise.
    arguments (Input)
        T table
        options.verbose (1,1) logical = true
    end
    arguments (Output)
        tf (1,1) logical
    end
    
    if isMATLABReleaseOlderThan("R2024b")
        varTypes = string(varfun(@class, T, 'OutputFormat', 'cell'));
    else
        varTypes = T.Properties.VariableTypes;
    end

    tf = true;
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


function [success, result] = doDropTable(tableName, database, cluster, options)
    arguments (Input)
        tableName string {mustBeTextScalar, mustBeNonzeroLengthText}
        database string {mustBeTextScalar, mustBeNonzeroLengthText}
        cluster {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end
    arguments (Output)
        success logical
        result table
    end

    if options.verbose; disp("Dropping table"); end
    dropResult = mathworks.adx.dropTable(tableName, database=database, cluster=cluster);
    if isa(dropResult, 'table')
        success = true;
        result = dropResult;
    elseif isa(dropResult, 'adx.control.models.ErrorResponse')
        disp(dropResult);
        success = false;
        result = table.empty;
    else
        fprintf(2, "Unexpected dropTable() return type: %s\n", class(dropResult));
        success = false;
        result = table.empty;
    end
end


function format = getFormat(localFile)
    arguments (Input)
        localFile {mustBeFile}
    end
    arguments (Output)
        format string
    end
    [~, ~, ext] = fileparts(localFile);
    ext = string(lower(strip(ext, "left", ".")));
    switch ext
        case "parquet"
            format = ext;
        otherwise
            format = ext;
            fprintf("File format not validated: %s\n", format);
            fprintf("Supported formats: parquet\n");
    end
end


function bearerToken = getBearerToken(database, cluster)
    arguments (Input)
        database string {mustBeTextScalar}
        cluster string {mustBeTextScalar}
    end
    arguments (Output)
        bearerToken string
    end

    q = adx.data.api.Query;
    if strlength(q.dataBearerToken) > 0
        bearerToken = q.dataBearerToken;
    else
        bearerToken = mathworks.internal.adx.getDataBearerToken(database, cluster);
    end
    
    if isempty(bearerToken) || strlength(bearerToken) == 0
        error("adx:ingestFile", "dataBearerToken value not set")
    end
end


function mapping = buildIngestMapping(variableTypes, variableNames, timeFromMicroseconds)
    arguments (Input)
        variableTypes string
        variableNames string
        timeFromMicroseconds (1,1) logical = true
    end
    arguments(Output)
        mapping string
    end

    assert(numel(variableTypes) == numel(variableNames));

    mapping = "ingestionMapping=" + newline + "```[" + newline;
    for n = 1:length(variableNames)
        if strcmp(variableTypes(n), "datetime") && timeFromMicroseconds
            lineStr = "    " + sprintf('{"Column":"%s", "Properties":{"Path": "$", "Transform":"DateTimeFromUnixMicroseconds"}}', variableNames(n));
        else
            lineStr = "    " + sprintf('{"Column":"%s", "Properties":{"Path": "$"}}', variableNames(n));
        end
        mapping = mapping +  lineStr;

        if n < length(variableNames)
            mapping = mapping + "," + newline;
        else
            mapping = mapping + newline;
        end
    end
    mapping = mapping + "]```" + newline;
end
