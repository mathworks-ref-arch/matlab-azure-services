function credentials = configureCredentials(configFilePath,varargin)
% CONFIGURECREDENTIALS Reads JSON configuration file and returns credentials object
% A configuration file path must be passed as a string or character vector.
% Authentication method to use is determined using the AuthMethod field of the
% JSON configuration file.
%
% Supported authentication methods are:
%   storageSharedKey (Azure Data Lake Storage Gen2 only)
%   connectionString (Azure Data Lake Storage Gen2 only)
%   environment
%   defaultAzure
%   clientSecret
%   interactiveBrowser
%   deviceCode
%   azurecli
%   managedIdentityCredentialBuilder
%
% The resulting credential object can then be used by the corresponding client
% builder.
%
% The function has one optional Name-Value input pair:
%
%   'DeviceCodeCallback', @myFunctionHandle
%
% This option is only valid when working with the DeviceCode method and it
% allows specifying a custom function for displaying the Device Code login
% instructions.

% Copyright 2020-2022 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~(ischar(configFilePath) || isStringScalar(configFilePath))
    write(logObj,'error','Expected configFilePath to be of type character vector or scalar string');
else
    configFilePath = char(configFilePath);
end


p = inputParser;
p.FunctionName = 'configureCredentials';
p.addParameter('DeviceCodeCallback',[],@(x)isa(x,'function_handle'));
p.parse(varargin{:});
options = p.Results;

settings = loadConfigurationSettings(configFilePath);

if ~isfield(settings, 'AuthMethod')
    write(logObj,'error','Expected AuthMethod field in settings');
else
    if isempty(settings.AuthMethod)
        write(logObj,'error','Expected AuthMethod field to have a value');
    end        
end

switch lower(settings.AuthMethod)
    case 'storagesharedkey'
        % Only supported in the case of Azure Data Lake Gen2
        if ~(isfield(settings, 'AccountName') && isfield(settings, 'AccountKey'))
            write(logObj,'error','AccountName and AccountKey settings fields are required for StorageSharedKeyCredential authentication');
        elseif isempty(settings.AccountName) || isempty(settings.AccountKey)
            write(logObj,'error','AccountName and AccountKey values are required for StorageSharedKeyCredential authentication');
        else
            credentials = azure.storage.common.StorageSharedKeyCredential(settings.AccountName, settings.AccountKey);
        end

    case 'connectionstring'
        % Only supported in the case of Azure Data Lake Gen2
        envStr = getenv('AZURE_STORAGE_CONNECTION_STRING');
        if isempty(envStr)
            if ~isfield(settings, 'ConnectionString')
                write(logObj,'error','ConnectionString settings field or AZURE_STORAGE_CONNECTION_STRING environment value are required for ConnectionString authentication');
            elseif isempty(settings.ConnectionString) 
                write(logObj,'error','ConnectionString value is required for ConnectionString authentication');
            else
            credentials = char(settings.ConnectionString);
            end
        else
            credentials = char(envStr); 
        end

    case 'environment'
        % Creates a credential using environment variables
        % Values are taken from environment variables:
        % AZURE_CLIENT_ID, AZURE_CLIENT_SECRET and AZURE_TENANT_ID
        % or
        % AZURE_CLIENT_ID, AZURE_CLIENT_CERTIFICATE_PATH and AZURE_TENANT_ID
        % or
        % AZURE_CLIENT_ID, AZURE_USERNAME and AZURE_PASSWORD
        %
        % Use Java getenv to check as that is the context the SDK will test at
        if ~(~isempty(java.lang.System.getenv('AZURE_CLIENT_ID')) && ...
            ~isempty(java.lang.System.getenv('AZURE_CLIENT_SECRET')) && ...
            ~isempty(java.lang.System.getenv('AZURE_TENANT_ID'))) || ...
            ...
           (~isempty(java.lang.System.getenv('AZURE_CLIENT_ID')) && ...
            ~isempty(java.lang.System.getenv('AZURE_CLIENT_CERTIFICATE_PATH')) && ...
            ~isempty(java.lang.System.getenv('AZURE_TENANT_ID'))) || ...
            ...
           (~isempty(java.lang.System.getenv('AZURE_CLIENT_ID')) && ...
            ~isempty(java.lang.System.getenv('AZURE_USERNAME')) && ...
            ~isempty(java.lang.System.getenv('AZURE_PASSWORD')))

            write(logObj,'verbose','Environment variables not set in the JVM context for EnvironmentCredentials');
            write(logObj,'verbose','Options are: AZURE_CLIENT_ID, AZURE_CLIENT_SECRET and AZURE_TENANT_ID');
            write(logObj,'verbose',' or AZURE_CLIENT_ID, AZURE_CLIENT_CERTIFICATE_PATH and AZURE_TENANT_ID');
            write(logObj,'verbose',' or AZURE_CLIENT_ID, AZURE_USERNAME and AZURE_PASSWORD');
        end
        if ~compareAuthEnvVars
            % Check for mismatches in Java and MATLAB that might indicate misconfiguration
            write(logObj,'warning','There is a mismatch between authentication variables in the MATLAB and Java contexts, the Azure SDK will use the Java values. To enable both, set variables in the environment used to start MATLAB.');
        end
        builder = azure.identity.EnvironmentCredentialBuilder();
        % Configure fields from the settings file if set
        if isfield(settings, 'AuthorityHost') && ~isempty(settings.AuthorityHost)
            builder = builder.authorityHost(settings.AuthorityHost);
        end
        % do the build
        builder = builder.httpClient();
        credentials = builder.build();

    case 'defaultazure'
        % DefaultAzureCredential tries to create a valid credential in the following order:
        %   EnvironmentCredential
        %   ManagedIdentityCredential
        %   SharedTokenCacheCredential
        %   IntelliJCredential
        %   VisualStudioCodeCredential
        %   AzureCliCredential
        %  Fails if none of the credentials above could be created.
        %
        builder = azure.identity.DefaultAzureCredentialBuilder();
        % Configure fields from the settings file if set
        if isfield(settings, 'TenantId') && ~isempty(settings.TenantId)
            builder = builder.tenantId(settings.TenantId);
        end
        if isfield(settings, 'ManagedIdentityClientId') && ~isempty(settings.ManagedIdentityClientId)
            builder = builder.managedIdentityClientId(settings.ManagedIdentityClientId);
        end
        if isfield(settings, 'AuthorityHost') && ~isempty(settings.AuthorityHost)
            builder = builder.authorityHost(settings.AuthorityHost);
        end
        % do the build
        builder = builder.httpClient();
        credentials = builder.build();
    

    case 'clientsecret'
        % TenantId and ClientId are always required
        if ~(isfield(settings, 'ClientId') && isfield(settings, 'TenantId'))
            write(logObj,'error','ClientId and TenantId settings fields are required for clientSecretCredential authentication');
        end
        if (isempty(settings.TenantId) || isempty(settings.ClientId))
            write(logObj,'error','Expected ClientId, TenantId and fields to have values for ClientSecretCredential authentication');
        end
        % The secret can be a pem file or ClientSecret string (other certificate formats are not currently supported, pfx is easy to add)
        if  ~(isfield(settings, 'pemCertificate') || isfield(settings, 'ClientSecret'))
            write(logObj,'error','pemCertificate or ClientSecret settings fields are required for clientSecretCredential authentication');
        end
        if  (isempty(settings.ClientId) &&  isempty(settings.pemCertificate))
            write(logObj,'error','Expected either ClientSecret or pemCertificate fields to have a value for ClientSecretCredential authentication');
        end
        % If a pem file is configured check it exists
        usePemfile = false;
        if isfield(settings, 'pemCertificate')
            if ~isempty(settings.pemCertificate)
                if exist(settings.pemCertificate, 'file') ~= 2
                    write(logObj,'error',['pem certificate file not found: ', strrep(char(settings.pemCertificate),'\','\\')]);
                else
                    usePemfile = true;
                end
            end
        end
        builder = azure.identity.ClientSecretCredentialBuilder();
        builder = builder.clientId(settings.ClientId);
        builder = builder.tenantId(settings.TenantId);
        % If a pem file is configured and exists use it else default to the client secret
        if usePemfile
            builder = builder.pemCertificate(settings.pemCertificate);
        else
            if isfield(settings, 'ClientSecret')
                if ~isempty(settings.ClientSecret)
                    builder = builder.clientSecret(settings.ClientSecret);
                else
                    write(logObj,'error','ClientSecret not set');
                end
            end
        end
        if isfield(settings, 'AuthorityHost') && ~isempty(settings.AuthorityHost)
            builder = builder.authorityHost(settings.AuthorityHost);
        end
        builder = builder.httpClient();
        credentials = builder.build();

    case 'interactivebrowser'
        % TenantId and ClientId are always required
        if ~(isfield(settings, 'ClientId') && isfield(settings, 'TenantId') && isfield(settings, 'RedirectUrl'))
            write(logObj,'error','ClientId, TenantId and RedirectUrl settings fields are required for InteractiveBrowserCredential authentication');
        end
        if (isempty(settings.TenantId) || isempty(settings.ClientId) || isempty(settings.RedirectUrl))
            write(logObj,'error','Expected ClientId, TenantId and RedirectUrl fields to have values for InteractiveBrowserCredential authentication');
        end

        builder = azure.identity.InteractiveBrowserCredentialBuilder();
        builder = builder.clientId(settings.ClientId);
        builder = builder.tenantId(settings.TenantId);
        builder = builder.redirectUrl(settings.RedirectUrl);
        builder = builder.httpClient();

        if (isfield(settings,'TokenCachePersistenceOptions'))
            % Start chain
            chainedCredentialBuilder = azure.identity.ChainedTokenCredentialBuilder;
        
            [sharedTokenCredential, tokenCachePersistanceOptions] = createSharedTokenCredential(settings);
            chainedCredentialBuilder = chainedCredentialBuilder.addLast(sharedTokenCredential);
            
            % Add persistence to existing builder, build and add to chain
            builder = builder.tokenCachePersistenceOptions(tokenCachePersistanceOptions);
            credentials = builder.build();
            builder = chainedCredentialBuilder.addLast(credentials);            
        end

        credentials = builder.build();

    case 'devicecode'
        % TenantId, ClientId and Scopes are always required
        if ~(isfield(settings, 'ClientId') && isfield(settings, 'TenantId') && isfield(settings,'Scopes'))
            write(logObj,'error','ClientId, TenantId and Scopes settings fields are required for DeviceCodeCredential authentication');
        end
        if (isempty(settings.TenantId) || isempty(settings.ClientId) || isempty(settings.Scopes))
            write(logObj,'error','Expected ClientId, TenantId and Scopes fields to have values for DeviceCodeCredential authentication');
        end
        
        trc = azure.core.credential.TokenRequestContext();
        trc.addScopes(settings.Scopes{:});

        if (isfield(settings,'TokenCachePersistenceOptions'))
            % If persistence is requested, create sharedTokenCredential 
            [sharedTokenCredential, tokenCachePersistanceOptions] = createSharedTokenCredential(settings);
            % And try to authorize the requested scopes with this
            try
                sharedTokenCredential.getToken(trc);
                % If that works, actually continue with this
                % sharedTokenCredential and do not bother building a
                % DeviceCodeCredential, it is not needed
            catch
                % If this failed, create a DeviceCodeCredentialBuiler
                dvcbuilder = createDeviceCodeCredentialBuiler(settings);
                % Add persistence options
                dvcbuilder = dvcbuilder.tokenCachePersistenceOptions(tokenCachePersistanceOptions);
                % And authenticate this
                if isempty(options.DeviceCodeCallback)
                    dvcbuilder.buildAndAuthenticate(trc);
                else
                    dvcbuilder.buildAndAuthenticate(trc,options.DeviceCodeCallback);
                end
                % At this point the credentials are in the cache, so in the
                % end actually return the SharedTokenCredential rather than
                % the DeviceCodeCredential, the latter has no added value
            end
            credentials = sharedTokenCredential;
        else % If no caching
            % Just build and authorize the standard DeviceCodeCredential
            builder = createDeviceCodeCredentialBuiler(settings);
            if isempty(options.DeviceCodeCallback)
                credentials = builder.buildAndAuthenticate(trc);
            else
                credentials = builder.buildAndAuthenticate(trc,options.DeviceCodeCallback);
            end
        end

    case 'sharedtokencache'
        % TenantId, ClientId aare always required
        if ~(isfield(settings, 'ClientId') && isfield(settings, 'TenantId'))
            write(logObj,'error','ClientId and TenantId settings fields are required for SharedTokenCacheCredential authentication');
        end
        if (isempty(settings.TenantId) || isempty(settings.ClientId))
            write(logObj,'error','Expected ClientId and TenantId fields to have values for SharedTokenCacheCredential authentication');
        end
        credentials = createSharedTokenCredential(settings);
        
    case 'managedidentity'
        if ~isfield(settings, 'ManagedIdentityClientId')
            write(logObj,'error','ManagedIdentityClientId settings field is required for managedIdentityCredential authentication');
        end
        builder = azure.identity.ManagedIdentityCredentialBuilder();
        builder = builder.clientId(settings.ManagedIdentityClientId);
        builder = builder.httpClient();
        builder = builder.maxRetry(int32(1));
        credentials = builder.build();

    case 'azurecli'
        builder = azure.identity.AzureCliCredentialBuilder();
        credentials = builder.build();

    case 'chainedtoken'
        % TODO
        write(logObj,'error','Chained Token Credential configuration not yet implemented');

    otherwise
        write(logObj,'error',['AuthMethod not supported: ', settings.AuthMethod]);
end

end

function builder = createDeviceCodeCredentialBuiler(settings)
    builder = azure.identity.DeviceCodeCredentialBuilder();
    builder = builder.httpClient();
    builder = builder.maxRetry(int32(1));
    builder = builder.clientId(settings.ClientId);
    builder = builder.tenantId(settings.TenantId);

    if isfield(settings, 'AuthorityHost') && ~isempty(settings.AuthorityHost)
        builder = builder.authorityHost(settings.authorityHost);
    end 
end

function [sharedTokenCredential, tokenCachePersistanceOptions] = createSharedTokenCredential(settings)
    % Define cache properties
    tokenCachePersistanceOptions = azure.identity.TokenCachePersistenceOptions;
    if isfield(settings.TokenCachePersistenceOptions, 'Name') && ~isempty(settings.TokenCachePersistenceOptions.Name)
        tokenCachePersistanceOptions = tokenCachePersistanceOptions.setName(settings.TokenCachePersistenceOptions.Name);
    end
   
    % Create SharedTokenCacheCredential
    sharedTokenCredentialBuilder = azure.identity.SharedTokenCacheCredentialBuilder;
    sharedTokenCredentialBuilder = sharedTokenCredentialBuilder.clientId(settings.ClientId);
    sharedTokenCredentialBuilder = sharedTokenCredentialBuilder.tenantId(settings.TenantId);
    sharedTokenCredentialBuilder = sharedTokenCredentialBuilder.tokenCachePersistenceOptions(tokenCachePersistanceOptions);
    sharedTokenCredential = sharedTokenCredentialBuilder.build;
end
