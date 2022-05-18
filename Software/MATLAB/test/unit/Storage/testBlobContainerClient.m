classdef (SharedTestFixtures={storageFixture}) testBlobContainerClient < matlab.unittest.TestCase
% TESTBLOBCONTAINERCLIENT Tests Blob Container Client

% Copyright 2020-2022 The MathWorks, Inc.

% TODO deleteBlobContainer

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
    function testBuilderConstructor(testCase)
        disp('Running testBuilderConstructor');        
        % Create the Client
        builder = azure.storage.blob.BlobContainerClientBuilder();
        % Check the Handle
        testCase.verifyNotEmpty(builder.Handle);
        testCase.verifyClass(builder.Handle, 'com.azure.storage.blob.BlobContainerClientBuilder');
    end


    function testBuilderConnectionString(testCase)
        disp('Running testBuilderConnectionString');        
        % Create the Client        
        builder = azure.storage.blob.BlobContainerClientBuilder();
        
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        % ConnectionString should return a credential of type char
        testCase.verifyTrue(ischar(credentials));
        
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        builder = builder.containerName("containernotempty");
        client = builder.buildClient();

        % Check the Handle
        testCase.verifyNotEmpty(client.Handle);
        testCase.verifyClass(client.Handle, 'com.azure.storage.blob.BlobContainerClient');
    end


    function testListBlobs(testCase)
        disp('Running testListBlobs');        
        builder = azure.storage.blob.BlobContainerClientBuilder();
        
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        % ConnectionString should return a credential of type char
        testCase.verifyTrue(ischar(credentials));
        
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        builder = builder.containerName("containernotempty");
        client = builder.buildClient();

        results = client.listBlobs;
        for n = 1:numel(results)
            testCase.verifyClass(results(n), 'azure.storage.blob.models.BlobItem');
            testCase.verifyClass(results(n).Handle, 'com.azure.storage.blob.models.BlobItem');
            testCase.verifyTrue(ischar(results(n).getName));
            testCase.verifyFalse(isempty(results(n).getName));
        end        
    end
    
    function testListNoBlobs(testCase)
        disp('Running testListNoBlobs');        
        builder = azure.storage.blob.BlobContainerClientBuilder();
        
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        % ConnectionString should return a credential of type char
        testCase.verifyTrue(ischar(credentials));
        
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        builder = builder.containerName("containerempty");
        client = builder.buildClient();

        results = client.listBlobs;
        for n = 1:numel(results)
            testCase.verifyClass(results(n), 'azure.storage.blob.models.BlobItem');
            testCase.verifyClass(results(n).Handle, 'com.azure.storage.blob.models.BlobItem');
            testCase.verifyTrue(ischar(results(n).getName));
            testCase.verifyFalse(isempty(results(n).getName));
        end

        testCase.verifyEmpty(results);
    end
    
    function testSasToken(testCase)
        disp('Running testSasToken');        
        
        % Generates an AccountSasSignatureValues object that lasts for a day and gives
        % the user read and list access to blob and file shares.
        % UTC is used for the timezone in this case
        % Account is only used for unit test so a read only SAS is not
        % particularly sensitive and can be allowed to expire
        builder = azure.storage.blob.BlobServiceClientBuilder();
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_StorageSharedKey.json'));
        builder = builder.credential(credentials);
        builder = builder.httpClient();
        endpoint = ['https://', credentials.getAccountName(), '.blob.core.windows.net'];
        builder = builder.endpoint(endpoint);
        serviceClient = builder.buildClient();
        permissions = azure.storage.common.sas.AccountSasPermission();
        permissions = permissions.setListPermission(true);
        permissions = permissions.setReadPermission(true);
        resourceTypes = azure.storage.common.sas.AccountSasResourceType();
        resourceTypes = resourceTypes.setContainer(true);
        services = azure.storage.common.sas.AccountSasService();
        services = services.setBlobAccess(true);
        expiryTime = datetime('now', 'TimeZone', 'UTC') + days(1);
        sasValues = azure.storage.common.sas.AccountSasSignatureValues(expiryTime, permissions, services, resourceTypes);
        sas = serviceClient.generateAccountSas(sasValues);

        % test the sas with a BlobContainerClient
        builder = azure.storage.blob.BlobContainerClientBuilder();        
        builder = builder.sasToken(sas);
        builder = builder.httpClient();
        endpoint = ['https://', credentials.getAccountName(), '.blob.core.windows.net'];
        builder = builder.endpoint(endpoint);
        builder = builder.containerName("containernotempty");
        client = builder.buildClient();

        tf = client.exists();
        testCase.verifyTrue(tf);
        
        results = client.listBlobs;
        for n = 1:numel(results)
            testCase.verifyClass(results(n), 'azure.storage.blob.models.BlobItem');
            testCase.verifyClass(results(n).Handle, 'com.azure.storage.blob.models.BlobItem');
            testCase.verifyTrue(ischar(results(n).getName));
            testCase.verifyFalse(isempty(results(n).getName));
        end
    end

    function testUserDelegationSas(testCase)
        % Create a client secret based container client
        client = createStorageClient('ContainerName','containernotempty',...
            'ConfigurationFile','test_ClientSecret.json');

        % Get the corresponding service client
        sc = client.getServiceClient;
        % Obtain user delegationkey
        key = sc.getUserDelegationKey(datetime('now'),datetime('now')+minutes(10));
        testCase.verifyClass(key,?azure.storage.blob.models.UserDelegationKey);

        % Generate a SAS for reading and listing blobs
        permissions = azure.storage.blob.sas.BlobContainerSasPermission();

        permissions = permissions.setListPermission(true);
        permissions = permissions.setReadPermission(true);
        
        sasValues = azure.storage.blob.sas.BlobServiceSasSignatureValues(datetime('now')+minutes(10), permissions);

        sas = client.generateUserDelegationSas(sasValues,key);
        
        testCase.verifyNotEmpty(sas);
        testCase.verifyClass(sas,'char');


        % test the sas with a BlobContainerClient
        settings = loadConfigurationSettings('test_ClientSecret.json');

        builder = azure.storage.blob.BlobContainerClientBuilder();        
        builder = builder.sasToken(sas);
        builder = builder.httpClient();
        builder = builder.endpoint(sprintf('https://%s.blob.core.windows.net',settings.AccountName));
        builder = builder.containerName("containernotempty");
        client = builder.buildClient();
        
        results = client.listBlobs;
        for n = 1:numel(results)
            testCase.verifyClass(results(n), 'azure.storage.blob.models.BlobItem');
            testCase.verifyClass(results(n).Handle, 'com.azure.storage.blob.models.BlobItem');
            testCase.verifyTrue(ischar(results(n).getName));
            testCase.verifyFalse(isempty(results(n).getName));
        end
  

    end


    function testGetBlobContainerName(testCase)
        disp('Running testGetBlobContainerName');        
        builder = azure.storage.blob.BlobContainerClientBuilder();
        
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        % ConnectionString should return a credential of type char
        testCase.verifyTrue(ischar(credentials));
        
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        builder = builder.containerName("containernotempty");
        client = builder.buildClient();

        % Get the account name from the method and compare
        containerName = client.getBlobContainerName();
        testCase.verifyTrue(strcmp(containerName, 'containernotempty'));
    end


    function testGetAccountName(testCase)
        disp('Running testGetAccountName');        
        builder = azure.storage.blob.BlobContainerClientBuilder();
        
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        % ConnectionString should return a credential of type char
        testCase.verifyTrue(ischar(credentials));
        
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        builder = builder.containerName("containernotempty");
        client = builder.buildClient();

        % Get the account name from the connection string
        settings = loadConfigurationSettings(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        [starti, endi] = regexp(settings.ConnectionString,'AccountName=\w+;');
        nameFromConnStr = settings.ConnectionString(starti+12:endi-1);
        
        % Get the account name from the method and compare
        accountName = client.getAccountName();
        testCase.verifyTrue(strcmp(accountName, nameFromConnStr));
    end
    
    
    function testCreateDeleteExistBlobContainer(testCase)
        disp('Running testCreateDeleteExistBlobContainer');
        % UUID for container name
        import java.util.UUID;
        uuid = char(UUID.randomUUID());

        % Create a service client to check the creation
        builder = azure.storage.blob.BlobServiceClientBuilder();
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_StorageSharedKey.json'));
        builder = builder.credential(credentials);
        builder = builder.httpClient();
        endpoint = ['https://', credentials.getAccountName(), '.blob.core.windows.net'];
        builder = builder.endpoint(endpoint);
        serviceClient = builder.buildClient();

        containerName = ['unittestcontainer-',uuid];

        % Create a container client to create & delete the container
        builder = azure.storage.blob.BlobContainerClientBuilder();
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        builder = builder.containerName(containerName);
        client = builder.buildClient();

        % Check exists for false
        testCase.verifyFalse(client.exists);

        % create the container at this point
        client.create()
        
        results = serviceClient.listBlobContainers();
        found = false;
        for n = 1:numel(results)
            if strcmp(results(n).getName, containerName)
                found = true;
            end
        end
        testCase.verifyTrue(found);

        % Check exists for true
        testCase.verifyTrue(client.exists);

        % TODO Try to create the container client again what should happen?
        
        % delete the container and check it is gone using the service client
        client.deleteContainer();
        results = serviceClient.listBlobContainers();
        % Assume delete has removed the container
        found = false;
        for n = 1:numel(results)
            if strcmp(results(n).getName, containerName)
                found = true;
            end
        end
        testCase.verifyFalse(found);
    end
    

    function testGetBlobClient(testCase)
        disp('Running testGetBlobClient');          
        % Create a container client to create & delete the container
        builder = azure.storage.blob.BlobContainerClientBuilder();
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        builder = builder.containerName("containernotempty");
        client = builder.buildClient();

        % Get a blob name and create a client using it
        results = client.listBlobs;
        testCase.verifyClass(results(1), 'azure.storage.blob.models.BlobItem');
        testCase.verifyClass(results(1).Handle, 'com.azure.storage.blob.models.BlobItem');
        testCase.verifyTrue(ischar(results(1).getName));
        testCase.verifyFalse(isempty(results(1).getName));
        blobClient = client.getBlobClient(results(1).getName());

        % basic check of the blob client
        testCase.verifyNotEmpty(blobClient.Handle);
        testCase.verifyClass(blobClient.Handle, 'com.azure.storage.blob.BlobClient');       
    end
end %methods
end %class