classdef (SharedTestFixtures={storageFixture}) testBlobServiceClient < matlab.unittest.TestCase
% TESTBLOBSERVICECLIENT Tests Blob Service Client

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
    function testBuilderConstructor(testCase)
        disp('Running testBuilderConstructor');
        % Create the Client
        builder = azure.storage.blob.BlobServiceClientBuilder();
        % Check the Handle
        testCase.verifyNotEmpty(builder.Handle);
        testCase.verifyClass(builder.Handle, 'com.azure.storage.blob.BlobServiceClientBuilder');
    end


    function testBuilderConnectionString(testCase)
        disp('Running testBuilderConnectionString');
        % Create the Client        
        builder = azure.storage.blob.BlobServiceClientBuilder();
        
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        % ConnectionString should return a credential of type char
        testCase.verifyTrue(ischar(credentials));
        
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        client = builder.buildClient();

        % Check the Handle
        testCase.verifyNotEmpty(client.Handle);
        testCase.verifyClass(client.Handle, 'com.azure.storage.blob.BlobServiceClient');
    end


    function testListBlobContainers(testCase)
        disp('Running testListBlobContainers');
        builder = azure.storage.blob.BlobServiceClientBuilder();
        
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        % ConnectionString should return a credential of type char
        testCase.verifyTrue(ischar(credentials));
        
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        client = builder.buildClient();

        results = client.listBlobContainers();
        for n = 1:numel(results)
            testCase.verifyClass(results(n), 'azure.storage.blob.models.BlobContainerItem');
            testCase.verifyClass(results(n).Handle, 'com.azure.storage.blob.models.BlobContainerItem');
            testCase.verifyTrue(ischar(results(n).getName));
            testCase.verifyFalse(isempty(results(n).getName));
        end        
    end
    
    
    function testGetAccountName(testCase)
        disp('Running testGetAccountName');
        builder = azure.storage.blob.BlobServiceClientBuilder();
        
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        % ConnectionString should return a credential of type char
        testCase.verifyTrue(ischar(credentials));
        
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        client = builder.buildClient();

        % Get the account name from the connection string
        settings = loadConfigurationSettings(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        [starti, endi] = regexp(settings.ConnectionString,'AccountName=\w+;');
        nameFromConnStr = settings.ConnectionString(starti+12:endi-1);
        
        % Get the account name from the method and compare
        accountName = client.getAccountName();
        testCase.verifyTrue(strcmp(accountName, nameFromConnStr));
    end


    function testCreateDeleteBlobContainer(testCase)
        disp('Running testCreateDeleteBlobContainer');
        % UUID for container name
        import java.util.UUID;
        uuid = char(UUID.randomUUID());

        builder = azure.storage.blob.BlobServiceClientBuilder();
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_StorageSharedKey.json'));
        builder = builder.credential(credentials);
        builder = builder.httpClient();
        endpoint = ['https://', credentials.getAccountName(), '.blob.core.windows.net'];
        builder = builder.endpoint(endpoint);
        serviceClient = builder.buildClient();

        containerName = ['unittestcontainer-',uuid];
        containerClient = serviceClient.createBlobContainer(containerName);
        testCase.verifyNotEmpty(containerClient);

        results = serviceClient.listBlobContainers();
        found = false;
        for n = 1:numel(results)
            if strcmp(results(n).getName, containerName)
                found = true;
            end
        end
        testCase.verifyTrue(found);

        % Try to create the container client again and test that an empty is returned
        containerClient = serviceClient.createBlobContainer(containerName);
        testCase.verifyEmpty(containerClient);

        serviceClient.deleteBlobContainer(containerName);
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
    

    function testGenSas(testCase)
        disp('Running testGenSas');
        
        builder = azure.storage.blob.BlobServiceClientBuilder();
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_StorageSharedKey.json'));
        builder = builder.credential(credentials);
        builder = builder.httpClient();
        endpoint = ['https://', credentials.getAccountName(), '.blob.core.windows.net'];
        builder = builder.endpoint(endpoint);
        serviceClient = builder.buildClient();
    
        % Generates an AccountSasSignatureValues object that lasts for a day and gives
        % the user read and list access to blob and file shares.
        % UTC is used for the timezone in this case
        % Account is only used for unit test so a read only SAS is not
        % particularly sensitive and can be allowed to expire
        permissions = azure.storage.common.sas.AccountSasPermission();
        permissions = permissions.setListPermission(true);
        permissions = permissions.setReadPermission(true);

        resourceTypes = azure.storage.common.sas.AccountSasResourceType();
        resourceTypes = resourceTypes.setContainer(true);
        services = azure.storage.common.sas.AccountSasService();
        services = services.setBlobAccess(true);
        services = services.setFileAccess(true);

        expiryTime = datetime('now', 'TimeZone', 'UTC') + days(1);
    
        sasValues = azure.storage.common.sas.AccountSasSignatureValues(expiryTime, permissions, services, resourceTypes);
    
        % Client must be authenticated via StorageSharedKeyCredential
        sas = serviceClient.generateAccountSas(sasValues);
        testCase.verifyNotEmpty(sas);
        testCase.verifyTrue(ischar(sas));
        % Check for the sv and se fields, if these are present the SAS is
        % probably properly formed
        testCase.verifyTrue(contains(sas, 'sv='));
        testCase.verifyTrue(contains(sas, ['se=', char(datetime(expiryTime, 'Format', 'yyyy-MM-dd')), 'T']));        
    end

end %methods
end %class