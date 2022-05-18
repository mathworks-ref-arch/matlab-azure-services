classdef (SharedTestFixtures={commonFixture}) testCredentials < matlab.unittest.TestCase
    % TESTCREDENTIALS Tests Credentials using Blob Service Client
    
    % Copyright 2022 The MathWorks, Inc.
    
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
    
    
    methods (TestClassSetup)

    end
    
    methods (TestClassTeardown)
        % Delete Configuration Files
    end

    methods
        function interactWithClient(testCase, client, credentials, configFile)
            switch client
                case 'BlobServiceClient'
                    client = createStorageClient( ...
                        'Credentials',credentials, ...
                        'ConfigurationFile',configFile);

                    % Check the resulting client works
                    testCase.verifyNotEmpty(client.Handle);
                    testCase.verifyClass(client.Handle, 'com.azure.storage.blob.BlobServiceClient');
                    results = client.listBlobContainers();
                    testCase.verifyClass(results(1), 'azure.storage.blob.models.BlobContainerItem');
                case 'BlobContainerClient'

                    client = createStorageClient( ...
                        'Credentials',credentials, ...
                        'ContainerName','shouldnotexist', ...
                        'ConfigurationFile',configFile);

                    % Check the resulting client works
                    testCase.verifyNotEmpty(client.Handle);
                    testCase.verifyClass(client.Handle, 'com.azure.storage.blob.BlobContainerClient');
                    results = client.exists();
                    testCase.verifyFalse(results);
                case 'BlobClient'

                    client = createStorageClient( ...
                        'Credentials',credentials,...
                        'ContainerName','shouldnotexist', ...
                        'BlobName','shouldnotexist', ...
                        'ConfigurationFile',configFile);

                    % Check the resulting client works
                    testCase.verifyNotEmpty(client.Handle);
                    testCase.verifyClass(client.Handle, 'com.azure.storage.blob.BlobClient');
                    results = client.exists();
                    testCase.verifyFalse(results);            
                case 'QueueServiceClient'
                    client = createStorageClient( ...
                        'Type','QueueService', ...
                        'ConfigurationFile',configFile);

                    % Check the resulting client works
                    testCase.verifyNotEmpty(client.Handle);
                    testCase.verifyClass(client.Handle, 'com.azure.storage.queue.QueueServiceClient');
                    results = client.listQueues();
                    testCase.verifyClass(results(1), 'azure.storage.queue.models.QueueItem');
                case 'QueueClient'
                    client = createStorageClient( ...
                        'QueueName',['credential-test-' char(java.util.UUID.randomUUID)], ...
                        'ConfigurationFile',configFile);
                    
                    % Check the resulting client works
                    testCase.verifyNotEmpty(client.Handle);
                    testCase.verifyClass(client.Handle, 'com.azure.storage.queue.QueueClient');
                    client.create();
                    client.deleteQueue();
            end
        end
    end
    
    properties(TestParameter)
        Client = {'BlobServiceClient','BlobContainerClient','BlobClient','QueueServiceClient','QueueClient'}
    end

    methods (Test)
        
        function testBuilderConnectionString(testCase,Client)
            disp('Running testBuilderConnectionString');
            configFile = fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json');
            credentials = configureCredentials(configFile);
            % ConnectionString should return a credential of type char
            testCase.verifyTrue(ischar(credentials));
            
            testCase.interactWithClient(Client,credentials,configFile);
        end
        
        
        function testBuilderStorageSharedKey(testCase,Client)
            disp('Running testBuilderStorageSharedKey');
            
            % Configure StorageSharedKey credentials
            configFile = fullfile(AzureCommonRoot, 'config', 'test_StorageSharedKey.json');
            credentials = configureCredentials(configFile);
            testCase.verifyClass(credentials, 'azure.storage.common.StorageSharedKeyCredential');
            testCase.interactWithClient(Client,credentials,configFile);
        end
        
        
        function testBuilderDefaultAzure(testCase,Client)
            disp('Running testBuilderDefaultAzure');
            if (isempty(java.lang.System.getenv('AZURE_CLIENT_ID')) || ...
                    isempty(java.lang.System.getenv('AZURE_CLIENT_SECRET')) || ...
                    isempty(java.lang.System.getenv('AZURE_TENANT_ID')))
                warning('Environment variables: AZURE_CLIENT_ID, AZURE_CLIENT_SECRET and AZURE_TENANT_ID not set in the JVM context for DefaultAzureCredentials');
                warning('Skipping test');
            else
                % Configure credentials file to test ID overrides
                configFile = fullfile(AzureCommonRoot, 'config', 'test_DefaultAzure.json');
                credentials = configureCredentials(configFile);
                testCase.verifyClass(credentials, 'azure.identity.DefaultAzureCredential');
                testCase.interactWithClient(Client,credentials,configFile);
            end
        end
        
        
        function testBuilderEnvironmentCredential(testCase,Client)
            disp('Running testBuilderEnvironmentCredential');
            
            if (isempty(java.lang.System.getenv('AZURE_CLIENT_ID')) || ...
                    isempty(java.lang.System.getenv('AZURE_CLIENT_SECRET')) || ...
                    isempty(java.lang.System.getenv('AZURE_TENANT_ID')))
                warning('Environment variables: AZURE_CLIENT_ID, AZURE_CLIENT_SECRET and AZURE_TENANT_ID not set in the JVM context for EnvironmentCredential');
                warning('Skipping test');
            else
                % Configure credentials file to test ID overrides
                configFile = fullfile(AzureCommonRoot, 'config', 'test_Environment.json');
                credentials = configureCredentials(configFile);
                testCase.verifyClass(credentials, 'azure.identity.EnvironmentCredential');
                testCase.interactWithClient(Client,credentials,configFile);
            end
        end
        
        
        function testBuilderClientSecret(testCase,Client)
            disp('Running testBuilderClientSecret');
            configFile = fullfile(AzureCommonRoot, 'config', 'test_ClientSecret.json');
            % Configure ClientSecret credentials
            credentials = configureCredentials(configFile);
            testCase.verifyClass(credentials, 'azure.identity.ClientSecretCredential');
            
            testCase.interactWithClient(Client,credentials,configFile);
        end
        
        
        function testBuilderInteractiveBrowser(testCase,Client) 
            disp('Running testBuilderInteractiveBrowser');
            
            % Don't run this test on the CI system
            if strcmpi(getenv('GITLAB_CI'), 'true')
                warning('Cannot execute testBuilderInteractiveBrowser in a pipeline, skipping');
            else
                % Configure interactive credentials
                configFile = fullfile(AzureCommonRoot, 'config', 'test_InteractiveBrowser.json');
                credentials = configureCredentials(configFile);
                %testCase.verifyClass(credentials, 'azure.identity.InteractiveBrowserCredential');

                testCase.interactWithClient(Client,credentials,configFile);
            end
        end
        
        
        function testBuilderDeviceCode(testCase,Client) 
            disp('Running testBuilderDeviceCode');
            
            % Don't run this test on the CI system
            if strcmpi(getenv('GITLAB_CI'), 'true')
                warning('Cannot execute testBuilderDeviceCode in a pipeline, skipping');
            else
                configFile = fullfile(AzureCommonRoot, 'config', 'test_DeviceCode.json');
                % Configure interactive credentials
                credentials = configureCredentials(configFile);
                %testCase.verifyClass(credentials, 'azure.identity.DeviceCodeCredential');

                testCase.interactWithClient(Client,credentials,configFile);
            end
        end
        
        
        function testBuilderChainedToken(testCase,Client)
            disp('Running testBuilderChainedToken');
            configFile = fullfile(AzureCommonRoot, 'config', 'test_ClientSecret.json');
            % Configure ClientSecret credentials
            clientSecretCredentials = configureCredentials(configFile);
            % Create the chained credential builder that will take the client secret credential
            chainedTokenCredentialBuilder = azure.identity.ChainedTokenCredentialBuilder();
            chainedTokenCredentialBuilder = chainedTokenCredentialBuilder.addLast(clientSecretCredentials);
            
            % Could add further credentials here, but only those of type com.azure.identity.*
            % i.e. not connection string based or StorageSharedKeyCredential based
            
            % Build the chained credential and add it to the service client builder
            chainedTokenCredentials = chainedTokenCredentialBuilder.build();
            testCase.verifyClass(chainedTokenCredentials,'azure.identity.ChainedTokenCredential');

            
            testCase.interactWithClient(Client,chainedTokenCredentials,configFile);
        end
        
        
        function testBuilderAzureCli(testCase,Client)
            disp('Running testBuilderAzureCli');
            
            % Requires login via azlogin first so don't do this on the CI system
            if strcmpi(getenv('GITLAB_CI'), 'true')
                warning('Cannot execute testBuilderAzureCli in a pipeline, skipping');
            else
                % Configure StorageSharedKey credentials
                configFile = fullfile(AzureCommonRoot, 'config', 'test_AzureCli.json');
                credentials = configureCredentials(configFile);
                testCase.verifyClass(credentials, 'azure.identity.AzureCliCredential');
                testCase.interactWithClient(Client,credentials,configFile);
            end
        end
    end
end