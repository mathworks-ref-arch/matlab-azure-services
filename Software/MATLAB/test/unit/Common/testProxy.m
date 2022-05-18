classdef testProxy < matlab.unittest.TestCase
    % TESTCREDENTIALS Tests Credentials using Blob Service Client
    
    % Copyright 2020 The MathWorks, Inc.
    
    properties
        logObj
    end
    
    methods (TestMethodSetup)
        function testSetup(testCase)
            initialize('displayLevel', 'verbose', 'loggerPrefix', 'Azure:ADLSG2');
            testCase.logObj = Logger.getLogger();
        end
    end
    
    
    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>
        end
    end
    
    
    methods (Test)
        function testProxyArgs(testCase)
            disp('Running testProxyArgs');
            % Don't run this test on the CI system where the proxy will not be
            % set in MATLAB
            if strcmpi(getenv('GITLAB_CI'), 'true')
                warning('Cannot execute testProxyArgs in a pipeline, skipping');
            else
                proxyHost = char(java.lang.System.getProperty('tmw.proxyHost'));
                if isempty(proxyHost)
                    warning('No proxy configured cannot execute testProxyArgs, skipping');
                else
                    testCase.verifyNotEmpty(proxyHost);
                    
                    % Create credentials
                    settings = loadConfigurationSettings(fullfile(AzureCommonRoot, 'config', 'test_ClientSecret.json'));
                    clientSecretCredentialBuilder = azure.identity.ClientSecretCredentialBuilder();
                    clientSecretCredentialBuilder = clientSecretCredentialBuilder.clientId(settings.ClientId);
                    clientSecretCredentialBuilder = clientSecretCredentialBuilder.tenantId(settings.TenantId);
                    clientSecretCredentialBuilder = clientSecretCredentialBuilder.clientSecret(settings.ClientSecret);
                    if isfield(settings, 'AuthorityHost') && ~isempty(settings.AuthorityHost)
                        clientSecretCredentialBuilder = clientSecretCredentialBuilder.authorityHost(settings.AuthorityHost);
                    end
                    clientSecretCredentialBuilder = clientSecretCredentialBuilder.httpClient();
                    clientSecretCredentials = clientSecretCredentialBuilder.build();
                    
                    % Create the Service Client
                    blobServiceClientBuilder = azure.storage.blob.BlobServiceClientBuilder();
                    endpoint = ['https://', settings.AccountName, '.blob.core.windows.net'];
                    blobServiceClientBuilder = blobServiceClientBuilder.endpoint(endpoint);
                    blobServiceClientBuilder = blobServiceClientBuilder.credential(clientSecretCredentials);
                    blobServiceClientBuilder = blobServiceClientBuilder.httpClient();
                    blobServiceClient = blobServiceClientBuilder.buildClient();
                    
                    % Check the resulting client works
                    testCase.verifyNotEmpty(blobServiceClient.Handle);
                    testCase.verifyClass(blobServiceClient.Handle, 'com.azure.storage.blob.BlobServiceClient');
                    results = blobServiceClient.listBlobContainers();
                    testCase.verifyClass(results(1), 'azure.storage.blob.models.BlobContainerItem');
                end
            end
        end
    end
    
end
