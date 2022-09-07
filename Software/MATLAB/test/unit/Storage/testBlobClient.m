classdef (SharedTestFixtures={storageFixture}) testBlobClient < matlab.unittest.TestCase
% TESTBLOBCLIENT Tests Blob Container Client

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

methods (Static)
    function fileCleanup(fname)
        if exist(fname, 'file') == 2
            disp(['Cleaning up file: ', char(fname)]);
            delete(fname);
        end
    end
end

methods (Test)
    function testBuilderConstructor(testCase)
        disp('Running testBuilderConstructor');
        % Create the Client builder
        builder = azure.storage.blob.BlobClientBuilder();
        % Check the Handle
        testCase.verifyNotEmpty(builder.Handle);
        testCase.verifyClass(builder.Handle, 'com.azure.storage.blob.BlobClientBuilder');
    end


    function testBuilderConnectionString(testCase)
        disp('Running testBuilderConnectionString');
        % Create the Client
        builder = azure.storage.blob.BlobClientBuilder();
        
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        % ConnectionString should return a credential of type char
        testCase.verifyTrue(ischar(credentials));
        
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        builder = builder.containerName("containernotempty");
        builder = builder.blobName("blob1.txt");
        client = builder.buildClient();

        % Check the Handle
        testCase.verifyNotEmpty(client.Handle);
        testCase.verifyClass(client.Handle, 'com.azure.storage.blob.BlobClient');
    end


    function testExists(testCase)
        disp('Running testExists');
        builder = azure.storage.blob.BlobClientBuilder();
        
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        % ConnectionString should return a credential of type char
        testCase.verifyTrue(ischar(credentials));
        
        % check for a blob that should exist
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        builder = builder.containerName("containernotempty");
        builder = builder.blobName("blob1.txt");
        client = builder.buildClient();
        testCase.verifyTrue(client.exists());
        
        % check for a blob that should NOT exist
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        builder = builder.containerName("containernotempty");
        builder = builder.blobName("blobthatreallydoesnotexist.txt");
        client = builder.buildClient();
        testCase.verifyFalse(client.exists());
    end
    

    function testGetBlobUrl(testCase)
        disp('Running testGetBlobUrl');
        builder = azure.storage.blob.BlobClientBuilder();
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        % ConnectionString should return a credential of type char
        testCase.verifyTrue(ischar(credentials));
        
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        builder = builder.containerName("containernotempty");
        builder = builder.blobName("blob1.txt");
        client = builder.buildClient();

        url = client.getBlobUrl();
        testCase.verifyTrue(ischar(url));
        testCase.verifyNotEmpty(url);
        testCase.verifyTrue(strcmp(url, ['https://', client.getAccountName,'.blob.core.windows.net/containernotempty/blob1.txt']));
    end

       
    function testSasToken(testCase)
        disp('Running testSasToken');
        % generate an account SAS
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
        resourceTypes = resourceTypes.setObject(true);
        services = azure.storage.common.sas.AccountSasService();
        services = services.setBlobAccess(true);
        expiryTime = datetime('now', 'TimeZone', 'UTC') + days(1);
        sasValues = azure.storage.common.sas.AccountSasSignatureValues(expiryTime, permissions, services, resourceTypes);
        sas = serviceClient.generateAccountSas(sasValues);

        % test the sas with a BlobClient exists call
        builder = azure.storage.blob.BlobClientBuilder();
        builder = builder.sasToken(sas);
        builder = builder.httpClient();
        builder = builder.endpoint(endpoint);
        builder = builder.containerName("containernotempty");
        builder = builder.blobName("blob1.txt");
        client = builder.buildClient();

        testCase.verifyTrue(client.exists());
    end

    function testUserDelegationSas(testCase)
        % Create a client secret based blob client
        client = createStorageClient('ContainerName','containernotempty',...
            'BlobName','blob1.txt',...
            'ConfigurationFile','test_ClientSecret.json');

        % Get the corresponding service client
        sc = client.getContainerClient.getServiceClient;
        % Obtain user delegationkey
        key = sc.getUserDelegationKey(datetime('now'),datetime('now')+minutes(10));
        testCase.verifyClass(key,?azure.storage.blob.models.UserDelegationKey);

        % Generate a read User Delegation Sas valid for 10 minutes
        permissions = azure.storage.blob.sas.BlobSasPermission();
        permissions = permissions.setReadPermission(true);
        sasValues = azure.storage.blob.sas.BlobServiceSasSignatureValues(datetime('now')+minutes(10), permissions);
        sas = client.generateUserDelegationSas(sasValues,key);
        
        testCase.verifyNotEmpty(sas);
        testCase.verifyClass(sas,'char');

        
        % test the sas with a BlobClient exists call
        settings = loadConfigurationSettings('test_ClientSecret.json');

        builder = azure.storage.blob.BlobClientBuilder();
        builder = builder.sasToken(sas);
        builder = builder.httpClient();
        builder = builder.endpoint(sprintf('https://%s.blob.core.windows.net',settings.AccountName));
        builder = builder.containerName("containernotempty");
        builder = builder.blobName("blob1.txt");
        client = builder.buildClient();
        testCase.verifyTrue(client.exists());

    end


    function testUploadDownloadFile(testCase)
        disp('Running testUploadDownloadFile');
        import java.util.UUID;
        uuid = char(UUID.randomUUID());
        containerName = ['unittestcontainer-',uuid];
        builder = azure.storage.blob.BlobContainerClientBuilder();
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        builder = builder.containerName(containerName);
        containerClient = builder.buildClient();
        containerClient.create();
        testCase.verifyTrue(containerClient.exists());
              
        % use temporary storage for file
        uploadFile = [tempname,'.mat'];
        [~, fileName, ext] = fileparts(uploadFile);
        blobName = [fileName, ext];
        builder = azure.storage.blob.BlobClientBuilder();
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        builder = builder.containerName(containerName);
        builder = builder.blobName(blobName);
        blobClient = builder.buildClient();

        % assume blob does not exist
        testCase.verifyFalse(blobClient.exists());

        % create a small block of data and save it to a file
        x = rand(100,100);
        cleanup = onCleanup(@()testBlobClient.fileCleanup(uploadFile));
        save(uploadFile, 'x');

        % do upload, don't rely on cleanup
        blobClient.uploadFromFile(uploadFile, 'overwrite', true);
        if exist(uploadFile, 'file') == 2
            delete(uploadFile);
        else
            error('upload file not found: %s', strrep(char(uploadFile),'\','\\'));
        end
           
        % exists should now return true
        testCase.verifyTrue(blobClient.exists());

        downloadFile = [tempname,'.mat'];
        cleanup = onCleanup(@()testBlobClient.fileCleanup(downloadFile));
        blobClient.downloadToFile(downloadFile, 'overwrite', true);

        testCase.verifyEqual(exist(downloadFile, 'file'), 2);

        % Take a copy of x and clear it so the reload is always from the
        % downloaded file
        xCopy = x;
        clear x;
        load(downloadFile, 'x');
        % test one of the random values
        testCase.verifyEqual(x(1,1), xCopy(1,1), 'AbsTol', 0.000001);

        if exist(downloadFile, 'file') == 2
            delete(downloadFile);
        else
            error('download file not found: %s', strrep(char(downloadFile),'\','\\'));
        end

        % delete the blob and check it is gone
        blobClient.deleteBlob();
        testCase.verifyFalse(blobClient.exists());

        % clean up the container
        containerClient.deleteContainer();
        testCase.verifyFalse(containerClient.exists());
    end

    function testUploadDownloadAltDir(testCase)
        disp('Running testUploadDownloadAltDir');
        import java.util.UUID;
        uuid = char(UUID.randomUUID());
        containerName = ['unittestcontainer-',uuid];
        builder = azure.storage.blob.BlobContainerClientBuilder();
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        builder = builder.containerName(containerName);
        containerClient = builder.buildClient();
        containerClient.create();
        testCase.verifyTrue(containerClient.exists());
              
        % Go into temp location
        loc = tempname;
        mkdir(loc);
        prevDir = cd(loc);
        % Go back to original location after test
        cleanup1 = onCleanup(@()cd(prevDir));

        % Create a file test.mat for upload here
        uploadFile = 'test.mat';
        x = rand(10);
        save(fullfile(loc,uploadFile),'x');

        % Start a new blob
        blobName = uploadFile;
        builder = azure.storage.blob.BlobClientBuilder();
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        builder = builder.containerName(containerName);
        builder = builder.blobName(blobName);
        blobClient = builder.buildClient();
        % Verify blob does not exist at first
        testCase.verifyFalse(blobClient.exists)
        
        % Upload the file using filename only, no absolute path
        blobClient.uploadFromFile(uploadFile);
    
        % Verify this succeeded by checking whether blob exists now
        testCase.verifyTrue(blobClient.exists)

        % Try to download the file overwriting existing file which should
        % fail.
        testCase.verifyError(@()blobClient.downloadToFile(uploadFile),'Azure:ADLSG2');

        % Replace local file such that after a download we can check that
        % it changed back
        y = rand(10);
        save(fullfile(loc,uploadFile),'y');
        
        % Download with overwrite, which should succeed
        blobClient.downloadToFile(uploadFile,'overwrite',true)
        % Verify that the local file now indeed contains x again
        data = load(fullfile(loc,uploadFile));
        testCase.verifyTrue(isfield(data,'x'));

        % Try download to new file with relative name
        blobClient.downloadToFile('newmat.mat')
        % Verify this was downloaded in local dir
        testCase.verifyTrue(isfile(fullfile(loc,'newmat.mat')));

        % Also try with relative subdir, which should fail if subdir does
        % not exist
        testCase.verifyError(@()blobClient.downloadToFile(fullfile('subdir',uploadFile)),'Azure:ADLSG2')
        % But succeed when it does
        mkdir('subdir');
        blobClient.downloadToFile(fullfile('subdir',uploadFile));
        
        % Verify that this file is also correct
        data = load(fullfile(loc,'subdir',uploadFile));
        testCase.verifyTrue(isfield(data,'x'));


        % Online Clean-up
        
        % delete the blob and check it is gone
        blobClient.deleteBlob();
        testCase.verifyFalse(blobClient.exists());

        % clean up the container
        containerClient.deleteContainer();
        testCase.verifyFalse(containerClient.exists());
        
        % Local clean-up
        cd(prevDir);
        rmdir(loc,'s')

    end


    function testCopyFromUrl(testCase)
        disp('Running testCopyFromUrl');
        import java.util.UUID;

        % Get a URL for the source
        builder = azure.storage.blob.BlobClientBuilder();
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        builder = builder.containerName("containernotempty");
        builder = builder.blobName("blob1.txt");
        srcClient = builder.buildClient();
        testCase.verifyTrue(srcClient.exists());
        permissions = azure.storage.blob.sas.BlobSasPermission();
        permissions = permissions.setReadPermission(true);
        expiryTime = datetime('now', 'TimeZone', 'UTC') + days(1);
        sasValues = azure.storage.blob.sas.BlobServiceSasSignatureValues(expiryTime, permissions);
        srcUrl = srcClient.getBlobUrl();
        srcSas = srcClient.generateSas(sasValues);
        srcStr = append(srcUrl, '?', srcSas);

        % Create a container for the destination blob
        uuid = char(UUID.randomUUID());
        containerName = ['unittestcontainer-',uuid];
        builder = azure.storage.blob.BlobContainerClientBuilder();
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        builder = builder.containerName(containerName);
        containerClient = builder.buildClient();
        containerClient.create();
        testCase.verifyTrue(containerClient.exists());

        destClient = containerClient.getBlobClient('destblobname.txt');
        destClient.copyFromUrl(srcStr);
        testCase.verifyTrue(destClient.exists());

        % Clean up the container
        containerClient.deleteContainer();
        testCase.verifyFalse(containerClient.exists());
    end

end %methods
end %class