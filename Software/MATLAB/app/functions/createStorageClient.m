function client = createStorageClient(varargin)
% CREATESTORAGECLIENT Convenience function for creating BlobServiceClient,
% BlobContainerClient, BlobClient, QueueServiceClient, QueueClient,
% DataLakeFileSystemClient, DataLakeDirectoryClient and DataLakeFileClient.
%
%   client = createStorageClient() creates a BlobServiceClient with default
%   options.
%
%   client = createStorageClient('ContainerName','myContainer')
%   creates BlobContainerClient with default options.
%
%   client = createStorageClient('ContainerName','myContainer',...
%               'BlobName','myBlob') creates a BlobClient with default options.
%
%   client = createStorageClient('Type','QueueService') creates a
%   QueueServiceClient with default options.
%
%   client = createStorageClient('QueueName','myQueue') creates a
%   QueueClient with default options.
%
%   client = createStorageClient('FileSystemName','myFileSystem') creates a
%   DataLakeFileSystemClient with default options.
%
%   client = createStorageClient('FileSystemName','myFileSystem',...
%               'DirectoryName','my/dir') creates a DataLakeDirectoryClient
%   with default options.
%
%   client = createStorageClient('FileSystemName','myFileSystem',...
%               'FileName','my/dir/file') creates a DataLakeFileClient with 
%   default options.
%
% By default createStorageClient reads Credential information and the
% Account Name (used to build the Client endpoint) from a configuration
% file named 'storagesettings.json'. The function automatically searches for
% this file on the MATLABPATH. It is possible to specify a different
% filename using 'ConfigurationFile'. It is also possible to provide
% 'Credentials' or 'SASToken' and 'AccountName' as inputs to the function
% directly in case which no configuration file may be needed. See the Name,
% Value pairs below for more details. An endpoint can be set if required
% e.g. if it does not conform to the default https://<AccountName>.<TYPE>.core.windows.net
% pattern, see below for EndPoint details.
%
% Additional Name, Value pairs can be supplied to configure non-default
% options:
%
%   'Type', explicitly specify the type of client to create. Required for
%       creating QueueServiceClient. In all other cases the type of client
%       is derived from whether 'ContainerName', 'BlobName', 'QueueName', 
%       'FileSystemName', 'DirectoryName', and/or 'FileName' are provided. 
%       With none of these configured a BlobServiceClient is created. If 
%       only BlobContainer is specified a BlobContainerClient is created,
%       if both BlobContainer and BlobName are specified a BlobClient is
%       created. If QueueName is specified a QueueClient is created. If 
%       only FileSystemName is specified a DataLakeFileSystemClient is
%       created, if DirectoryName is specified as well, a 
%       DataLakeDirectoryClient is created, or if FileName is specified a 
%       DataLakeFileClient is created.
%           
%       Possible Values: 'BlobService', 'BlobContainer', 'Blob',
%           'QueueService', 'QueueClient', 'DataLakeDirectory',
%           'DataLakeFile', or 'DataLakeFileSystem'.
%
%   'ConfigurationFile', explicitly specify which configuration file to
%       use. This file is used for configuring Credentials (when not 
%       supplied as input) and/or Account Name (when not supplied as input).
%
%       Default Value: 'storagesettings.json'
%
%   'Credentials', explicitly specify credentials to use. This for example
%       allows building multiple clients based on the same credentials
%       without having to go through (interactive) authentication again. If
%       neither this option nor 'SASToken' is specified, 
%       createStorageClient uses configureCredentials with 
%       'ConfigurationFile' as input to first configure credentials before
%       building the client. 
% 
%       Hint: configureCredentials can be used to build valid Credentials.
%
%       Example:
%           credentials = configureCredentials('myCredentials.json');
%           client1 = createStorageClient('Credentials',credentials,'ContainerName','container1')
%           client2 = createStorageClient('Credentials',credentials,'ContainerName','container2')
%
%   'SASToken', explicitly specify a SAS Token to use for authentication
%       rather than reading authentication details from a configuration
%       file or a credentials object passed in through the 'Credentials`
%       option. If neither this option nor 'Credentials' are specified,
%       createStorageClient uses configureCredentials with
%       'ConfigurationFile' as input to first configure credentials before
%       building the client. 
%   
%   'AccountName', explicitly specify the AccountName used to configure the
%       account and potentially the endpoint for the client.
%       If not specified createStorageClient uses loadConfigurationSettings
%       to load configuration options from 'ConfigurationFile'.
%       This file must then contain a "AccountName" setting.
%
%   'EndPoint', enables endpoint naming patterns other than:
%       https://<AccountName>.<TYPE>.core.windows.net
%       by explicitly specify the EndPoint used to configure the client.
%       If 'EndPoint' is not specified as an argument and an 'AccountName' is
%       provided then the 'AccountName' will be used to create a default endpoint.
%       If neither an 'EndPoint' or 'AccountName' argument is provided the
%       corresponding configuration file fields will be used with priority given
%       to "EndPoint".
%
%   See also CONFIGURECREDENTIALS, LOADCONFIGURATIONSETTINGS

% Copyright 2022-2023 The MathWorks, Inc.

    initialize('displayLevel', 'debug', 'loggerPrefix', 'Azure:ADLSG2');
    logObj = Logger.getLogger();

    p = inputParser;
    p.FunctionName = 'createStorageClient';
    
    p.addParameter('Credentials',[],@(x) ischar(x) || isStringScalar(x) || ...
        isa(x, 'azure.storage.common.StorageSharedKeyCredential') || ...
        isa(x, 'azure.core.credential.TokenCredential') || ...
        isa(x, 'azure.identity.ManagedIdentityCredential'));
    
    p.addParameter('Type',[],@(x) ischar(x) || isStringScalar(x));
    p.addParameter('ConfigurationFile','storagesettings.json',@(x) ischar(x) || isStringScalar(x))
    p.addParameter('ContainerName',[],@(x) ischar(x) || isStringScalar(x));
    p.addParameter('BlobName',[],@(x) ischar(x) || isStringScalar(x));
    p.addParameter('QueueName',[],@(x) ischar(x) || isStringScalar(x));
    p.addParameter('AccountName',[],@(x) ischar(x) || isStringScalar(x));
    p.addParameter('SASToken',[],@(x) ischar(x) || isStringScalar(x));
    p.addParameter('FileSystemName',[],@(x) ischar(x) || isStringScalar(x));
    p.addParameter('DirectoryName',[],@(x) ischar(x) || isStringScalar(x));
    p.addParameter('FileName',[],@(x) ischar(x) || isStringScalar(x));
    p.addParameter('EndPoint',[],@(x) ischar(x) || isStringScalar(x));

    p.parse(varargin{:});
    
    if isempty(p.Results.SASToken)
        if isempty(p.Results.Credentials)
            credentials = configureCredentials(p.Results.ConfigurationFile);
        else
            credentials = p.Results.Credentials;
        end
    end

    if isempty(p.Results.Type)
        if ~isempty(p.Results.QueueName)
            type = 'Queue';
        elseif ~isempty(p.Results.FileSystemName)
            if ~isempty(p.Results.DirectoryName)
                type = 'DataLakeDirectory';
            elseif ~isempty(p.Results.FileName)
                type = 'DataLakeFile';
            else
                type = 'DataLakeFileSystem';
            end
        elseif isempty(p.Results.ContainerName)
            type = 'BlobService';
        else
            if isempty(p.Results.BlobName)
                type = 'BlobContainer';
            else
                type = 'Blob';
            end
        end
    
    else
        type = p.Results.Type;
    end

    switch lower(type)
        case 'blobservice'
            builder = azure.storage.blob.BlobServiceClientBuilder();
            resource = 'blob';
        case 'blobcontainer'
            builder = azure.storage.blob.BlobContainerClientBuilder();
            resource = 'blob';
        case 'blob'
            builder = azure.storage.blob.BlobClientBuilder();
            resource = 'blob';
        case 'queueservice'
            builder = azure.storage.queue.QueueServiceClientBuilder();
            resource = 'queue';
        case 'queue'
            builder = azure.storage.queue.QueueClientBuilder();
            resource = 'queue';
        case 'datalakefilesystem'
            builder = azure.storage.file.datalake.DataLakeFileSystemClientBuilder();
            resource = 'dfs';
        case {'datalakefile','datalakedirectory'}
            builder = azure.storage.file.datalake.DataLakePathClientBuilder();
            resource = 'dfs';
        otherwise
            write(logObj,'error','Invalid Type requested.')
    end

    if isempty(p.Results.SASToken) && (ischar(credentials) || isStringScalar(credentials))
        builder = builder.connectionString(credentials);
    else
        if isempty(p.Results.SASToken)
            builder = builder.credential(credentials);
        else
            builder = builder.sasToken(p.Results.SASToken);
        end
        
        if ~isempty(p.Results.EndPoint)
            endpoint = p.Results.EndPoint;
        else
            if ~isempty(p.Results.AccountName)
                endpoint = sprintf('https://%s.%s.core.windows.net',p.Results.AccountName,resource);
            else
                config = loadConfigurationSettings(p.Results.ConfigurationFile);
                if isfield(config, 'EndPoint')
                    endpoint = config.EndPoint;
                else
                    if isfield(config, 'AccountName')
                        endpoint = sprintf('https://%s.%s.core.windows.net',config.AccountName,resource);
                    else
                        write(logObj,'error','An EndPoint has not been provided as an argument or via a configuration file, as an AccountName value has also not been provided a default EndPoint value cannot be set.');
                    end
                end
            end
        end
        builder = builder.endpoint(endpoint);
    end

    switch lower(type)
        case 'blobservice'
        case 'blobcontainer'
            builder = builder.containerName(p.Results.ContainerName);
        case 'blob'
            builder = builder.containerName(p.Results.ContainerName);
            builder = builder.blobName(p.Results.BlobName);
        case 'queueservice'
        case 'queue'
            builder = builder.queueName(p.Results.QueueName);
        case 'datalakefilesystem'
            builder = builder.fileSystemName(p.Results.FileSystemName);
        case 'datalakefile'
            builder = builder.fileSystemName(p.Results.FileSystemName);
            builder = builder.pathName(p.Results.FileName);
        case 'datalakedirectory'
            builder = builder.fileSystemName(p.Results.FileSystemName);
            builder = builder.pathName(p.Results.DirectoryName);
    end

    builder = builder.httpClient();

    switch lower(type)
        case 'datalakefile'
            client = builder.buildFileClient();
        case 'datalakedirectory'
            client = builder.buildDirectoryClient();
        otherwise
            client = builder.buildClient();
    end

end