function success = ingestFileQueue(localFile, options)
    % INGESTSINGLEFILE Ingests a local file to Azure Data Explorer using Azure blob & queue
    % 
    % Arguments:
    %      localFile: Path to file to be ingested.
    %
    % Optional named arguments:
    %       database: database name, if not specified the database configured in
    %                 the JSON settings file will be used.
    %         format: Format of the file to be ingested, if not specified the file
    %                 extension will be used.
    %       blobName: Name of the blob to upload to, if not specified a name will be
    %                 generated based on the local file.
    %        cluster: Cluster name, if not specified the database configured in
    %                 the JSON settings file will be used.
    %    bearerToken: Bearer Token, if not specified the database configured in
    %                 the JSON settings file will be used.
    %      tableName: Table to ingest the data to, default is ingestedTable-<timeDateStamp>
    %
    % Return values
    %        success: A logical true is returned if a success message is returned.
    %
    % Example:
    %    % Get filename & path for the outages.parquet file
    %    info = parquetinfo('outages.parquet');
    %    success = mathworks.adx.ingestFileQueue(info.Filename, 'tableName', 'outagesTable')

    % Copyright 2023-2024 The MathWorks, Inc.

    arguments
        % TODO remove default localFile post testing
        localFile string {mustBeTextScalar} % DEBUG ONLY= '/usr/local/MATLAB/R2022b/toolbox/matlab/demos/outages.parquet'
        options.database string {mustBeTextScalar}
        options.format string {mustBeTextScalar}
        options.blobName string {mustBeTextScalar}
        options.cluster string {mustBeTextScalar}
        options.bearerToken string {mustBeTextScalar}
        options.tableName string {mustBeTextScalar} = "ingestedTable-" + string(datetime('now', 'Format', 'uuuuMMdd''T''HHmmss', 'TimeZone', 'UTC'))
    end
    
    disp([newline, "Warning: ingestFileQueue is still under development and should not be used at this time!", newline]);

    disp(['Starting file ingestion: ', char(localFile)]);
    if ~isfile(localFile)
        error("adx:IngestSingleFile", "File not found: %s", localFile)
    end

    if isfield(options, 'blobName')
        blobName = options.blobName;
    else
        [~, name, ext] = fileparts(localFile);
        blobName = strcat(name, ext);
        blobName = sanitizeBlobName(blobName);
    end

    if isfield(options, 'database')
        database = options.database;
    else
        % Create a client to get the default database name
        % the client is not used.
        managementClient = adx.data.api.Management();
        database = managementClient.database;
    end

    % TODO add link to supported formats
    if ~isfield(options, 'format')
        [~, ~, ext] = fileparts(localFile);
        if strlength(ext) > 0
            if startsWith(ext,".")
                format = extractAfter(ext, ".");
            else
                format = ext;
            end
            if ~strcmpi(format, 'parquet')
                warning("adx:IngestSingleFile", "Format type not yet validated: %s", format)
            end
        else
            error("adx:IngestSingleFile", "Format cannot be determined from filename: %s", localFile)
        end
    else
        format = options.format;
    end

    disp('Getting bearerToken');
    if ~isfield(options, 'dataBearerToken') || strlength(options.dataBearerToken) == 0
        options.bearerToken = getDataBearerToken(database, cluster);
    end

    % Configure arguments
    args = mathworks.utils.addArgs(options, ["bearerToken", "cluster"]);
    disp('Retrieving ingestion resources');
    ingestionResources = retrieveIngestionResources(args{:});
    disp('Retrieving Kusto identity token');
    identityToken = retrieveKustoIdentityToken(args{:});

    % Upload file to one of the blob containers we got from Azure Data Explorer.
    % This example uses the first one, but when working with multiple blobs,
    % one should round-robin the containers in order to prevent throttling
    disp('Uploading to blob');
    [blobUriWithSas, blobSize] = UploadFileToBlobContainer(ingestionResources, blobName, localFile);

    disp('Composing ingestion command');
    if ~isfield(identityToken, 'token')
        error("adx:IngestSingleFile", "Identity token not found")
    else
        ingestionMessage = prepareIngestionMessage(blobUriWithSas, blobSize, format, identityToken.token, database, options.tableName);
    end

    disp('Posting ingestion command to queue');
    % Post ingestion command to one of the previously obtained ingestion queues.
    % This example uses the first one, but when working with multiple blobs,
    % one should round-robin the queues in order to prevent throttling
    if ~isfield(ingestionResources, 'SecuredReadyForAggregationQueue')
        error("adx:IngestSingleFile", "SecuredReadyForAggregationQueue name not found")
    else
        % TODO consider load balancing
        sendMessageResult = postMessageToQueue(matlab.net.URI(ingestionResources.SecuredReadyForAggregationQueue(1)), ingestionMessage); %#ok<NASGU> 
    end

    wait = 20; % TODO consider how to handle this robustly
    fprintf('Waiting for %ds...\n', wait);
    countDown(wait);
    
    disp("Read success notifications");
    if ~isfield(ingestionResources, 'SuccessfulIngestionsQueue')
        error("adx:IngestSingleFile", "SuccessfulIngestionsQueue name not found")
    else
        % TODO consider load balancing
        successes = PopTopMessagesFromQueue(matlab.net.URI(ingestionResources.SuccessfulIngestionsQueue(1)), 32);
    end

    if isempty(successes)
        successesTf = false;
    else
        successesTf = true;
        for n = 1:numel(successes)
            fprintf('Ingestion complete: %s\n', successes(n));
        end
    end

    disp('Read failure notifications');
    if ~isfield(ingestionResources, 'FailedIngestionsQueue')
        error("adx:IngestSingleFile", "FailedIngestionsQueue name not found")
    else
        errors = PopTopMessagesFromQueue(matlab.net.URI(ingestionResources.FailedIngestionsQueue(1)), 32);
    end
    if isempty(errors)
        failedTf = false;
    else
        failedTf = false;
        for n = 1:numel(errors)
            fprintf('Ingest error: %s\n', errors(n));
        end
    end

    if ~successesTf && ~failedTf
        fprintf('Ingest error, neither success or failure detected\n');
    end

    success = successesTf;
end


function countDown(wait)
    % countDown displays a countDown of wait seconds
    arguments
        wait int32 {mustBeNonnegative, mustBeReal}
    end

    for n = 1:wait
        fprintf("%d ", wait - n + 1);
        pause(1);
        if mod(n, wait) == 0 && n ~= wait
            fprintf("\n");
        end
    end
    fprintf("\n");
end


function bearerToken = getBearerToken(database, cluster)
    % getBearerToken Gets a bearer token by forcing a query
    arguments
        database string {mustBeTextScalar, mustBeNonzeroLengthText}
        cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    req = adx.data.models.QueryRequest('db', database, 'csl', 'print Test="Hello, World!"');
    q = adx.data.api.Query('cluster', cluster);
    [code, result, response] = q.queryRun(req); %#ok<*ASGLU>

    if code ~= matlab.net.http.StatusCode.OK
        error("adx:IngestSingleFile:getBearerToken", "Error getting bearer token");
    else
        bearerToken = q.bearerToken;
    end
end


function result = sanitizeBlobName(blobName)
    % sanitizeBlobName Checks that a name complies with Blob name limits
    arguments
        blobName string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % TODO apply blob name restrictions
    % blobName = lower(matlab.lang.makeValidName(['adxingesttemporaryblob',char(datetime('now'))],'ReplacementStyle','delete'));
    result = blobName;
end


function messages = PopTopMessagesFromQueue(queueUriWithSas, count)
    % PopTopMessagesFromQueue Returns count messages from a given queue
    arguments
        queueUriWithSas (1,1) matlab.net.URI
        count (1,1) int32 {mustBePositive}
    end

    endPoint = strcat(queueUriWithSas.Scheme, "://", queueUriWithSas.EncodedAuthority, queueUriWithSas.EncodedPath);
    sasToken = queueUriWithSas.EncodedQuery;
    qClient = createStorageClient('QueueName', queueUriWithSas.Path(end), 'SASToken', sasToken, 'EndPoint', endPoint);
    messagesFromQueue = qClient.receiveMessages('maxMessages', count);
    messages = string.empty;
    for n = 1:numel(messagesFromQueue)
        messages(end+1) = messagesFromQueue(n).getMessageText; %#ok<AGROW>
    end
end


function sendMessageResult = postMessageToQueue(queueURI, message)
    % postMessageToQueue
    arguments
        queueURI (1,1) matlab.net.URI
        message string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
   
    endPoint = strcat(queueURI.Scheme, "://", queueURI.EncodedAuthority, queueURI.EncodedPath);
    sasToken = queueURI.EncodedQuery;
    qClient = createStorageClient('QueueName',queueURI.Path(end), 'SASToken', sasToken, 'EndPoint', endPoint);
    sendMessageResult = qClient.sendMessage(message);
end


function [blobUriWithSas, blobSize] = UploadFileToBlobContainer(ingestionResources, blobName, localFile)
    % UploadFileToBlobContainer Uploads a file to a blob for ingestion
    arguments
        ingestionResources struct
        blobName string {mustBeTextScalar, mustBeNonzeroLengthText}
        localFile string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    if ~isfield(ingestionResources, 'TempStorage')
        error("adx:IngestSingleFile", "TempStorage name not found")
    else
        containerURI = matlab.net.URI(ingestionResources.TempStorage(1));
    end
    blobContainerClientBuilder = azure.storage.blob.BlobContainerClientBuilder();
    blobContainerClientBuilder.sasToken(containerURI.EncodedQuery);
    blobContainerClientBuilder.endpoint(strcat(containerURI.Scheme, "://", containerURI.EncodedAuthority, containerURI.EncodedPath));
    blobContainerClient = blobContainerClientBuilder.buildClient;
    blobClient = blobContainerClient.getBlobClient(blobName);
    blobClient.uploadFromFile(localFile, 'overwrite', true);
    blobProperties = blobClient.getProperties();
    blobSize = blobProperties.getBlobSize();
    blobUriWithSas = strcat(blobClient.getBlobUrl(), "?", containerURI.EncodedQuery);
end


function identityToken = retrieveKustoIdentityToken(options)
    arguments
        options.cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.bearerToken string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    args = {};
    if isfield(options, 'cluster')
        args{end+1} = "cluster";
        args{end+1} = options.cluster;
    end
    if isfield(options, 'bearerToken')
        args{end+1} = "bearerToken";
        args{end+1} = options.bearerToken;
    end
    managementClient = adx.data.api.Management(args{:});
   
    [code, result, ~] = managementClient.managementRun(adx.data.models.ManagementRequest('csl', '.get kusto identity token'));
    if code == matlab.net.http.StatusCode.OK
        identityToken = mathworks.utils.jwt.JWT(result.Tables.Rows{1});
    else
        error("adx:IngestSingleFile:retrieveKustoIdentityToken", "Error getting Identity token")
    end
end


function ingestionMessage = prepareIngestionMessage(blobUriWithSas, blobSize, format, identityToken, database, tableName)
    % prepareIngestionMessage Creates a JSON message to describe the ingestion
    arguments
        blobUriWithSas string {mustBeTextScalar, mustBeNonzeroLengthText}
        blobSize (1,1) int64
        format string {mustBeTextScalar, mustBeNonzeroLengthText}
        identityToken string {mustBeTextScalar, mustBeNonzeroLengthText}
        database string {mustBeTextScalar, mustBeNonzeroLengthText}
        tableName string {mustBeTextScalar, mustBeNonzeroLengthText} 
    end

    queueIngestionMessage = adx.data.models.QueueIngestionMessage;
    queueIngestionMessage.Id = mathworks.utils.UUID;
    queueIngestionMessage.BlobPath = blobUriWithSas;
    queueIngestionMessage.RawDataSize = blobSize;
    queueIngestionMessage.TableName = tableName;
    queueIngestionMessage.DatabaseName = database;
    % TODO expose as an option
    queueIngestionMessage.RetainBlobOnSuccess = true; % Do not delete the blob on success
    queueIngestionMessage.FlushImmediately = true; % Do not aggregate
    queueIngestionMessage.ReportLevel = 2; % Report failures and successes (might incur perf overhead)
    queueIngestionMessage.AdditionalProperties("authorizationContext") = identityToken;
    % TODO needed for non parquet
    % queueIngestionMessage.AdditionalProperties("mappingReference") = "mappingRef?";
    queueIngestionMessage.AdditionalProperties("format") = format;
    ingestionMessage = queueIngestionMessage.jsonencode;
    if ~strcmpi(format, 'parquet')
        warning("IngestSingleFile:prepareIngestionMessage", "prepareIngestionMessage functionality complete for parquet only, not: %s", format);
    end
end


function irs = retrieveIngestionResources(options)
    % retrieveIngestionResources Get queues and other values to do ingestion
    arguments
        options.cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.bearerToken string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    args = {};
    if isfield(options, 'cluster')
        args{end+1} = "cluster";
        args{end+1} = options.cluster;
    end
    if isfield(options, 'bearerToken')
        args{end+1} = "bearerToken";
        args{end+1} = options.bearerToken;
    end
    managementClient = adx.data.api.Management(args{:});

    [code, result, response] = managementClient.managementRun(adx.data.models.ManagementRequest('csl', '.get ingestion resources')); 
    if code == matlab.net.http.StatusCode.OK
        irs = adx.data.models.IngestionResourcesSnapshot(result);
        % irsTable = irs.table; % TODO enable table conversion
    else
        error("adx:IngestSingleFile:retrieveIngestionResources", "Error getting Ingestion Resources")
    end
end
