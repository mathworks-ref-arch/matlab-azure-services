classdef (SharedTestFixtures={storageFixture}) testBlobLease < matlab.unittest.TestCase
    % TESTBLOBLEASECLIENT Tests Blob Leases

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


    methods (Static)
        function client = getBlobContainerClient
            credentials = configureCredentials(fullfile(AzureCommonRoot,'config','test_ConnectionString.json'));
            client = azure.storage.blob.BlobContainerClientBuilder()...
                .connectionString(credentials)...
                .containerName('leasetest')...
                .buildClient();
        end

        function client = getBlobClient
            credentials = configureCredentials(fullfile(AzureCommonRoot,'config','test_ConnectionString.json'));
            client = azure.storage.blob.BlobClientBuilder()...
                .connectionString(credentials)...
                .containerName('leasetest')...
                .blobName('file1.txt')...
                .buildClient();
        end
    end

    methods (Test)
        function testBlobContainerLeaseClientBuilder(testCase)
            % Get a container client
            containerClient = testBlobLease.getBlobContainerClient;
            % Build lease client based on the container client
            builder = azure.storage.blob.specialized.BlobLeaseClientBuilder;
            builder = builder.containerClient(containerClient);
            client = builder.buildClient();
            % Verify that this successfully created a BlobLeaseClient
            testCase.verifyClass(client,?azure.storage.blob.specialized.BlobLeaseClient)
        end

        function testBlobLeaseClientBuilder(testCase)
            % Get a blob client
            blobClient = testBlobLease.getBlobClient;
            % Build lease client based on the blob client
            builder = azure.storage.blob.specialized.BlobLeaseClientBuilder;
            builder = builder.blobClient(blobClient);
            client = builder.buildClient();
            % Verify that this successfully created a BlobLeaseClient
            testCase.verifyClass(client,?azure.storage.blob.specialized.BlobLeaseClient);
        end

        function testLeaseId(testCase)
            % Get a blob client
            blobClient = testBlobLease.getBlobClient;
            % Start building lease client based on blob client
            builder = azure.storage.blob.specialized.BlobLeaseClientBuilder;
            builder = builder.blobClient(blobClient);
            % Configure a specific id
            id = char(java.util.UUID.randomUUID);
            builder = builder.leaseId(id);
            % Build the client
            client = builder.buildClient();
            % Verify that client was created with requested id
            rId = client.getLeaseId();
            testCase.verifyEqual(rId,char(id));
        end


        function testAcquireAndRelease(testCase)
            % Get a blob client
            blobClient = testBlobLease.getBlobClient;
            % Build 2 lease clients based on the blob client
            builder = azure.storage.blob.specialized.BlobLeaseClientBuilder;
            builder = builder.blobClient(blobClient);
            leaseClient1 = builder.buildClient();
            leaseClient2 = builder.buildClient();
            % Get automatically assigned IDs
            id1 = leaseClient1.getLeaseId();
            id2 = leaseClient2.getLeaseId();
            testCase.verifyNotEqual(id1,id2)
            
            % Obtain a lease using client 1
            leaseID = leaseClient1.acquireLease(-1);
            % Should match first id
            testCase.verifyEqual(leaseID,id1);

            % Try obtaining a lease using client2, should fail
            try
                leaseClient2.acquireLease(-1);
                testCase.verifyFail;
            catch ME
                err = ME.ExceptionObject.getErrorCode;
                testCase.verifyEqual(err,com.azure.storage.blob.models.BlobErrorCode.LEASE_ALREADY_PRESENT)
            end
            % Release the lease
            leaseClient1.releaseLease();

            % Verify that client 2 can now obtain a lease
            leaseID = leaseClient2.acquireLease(-1);
            testCase.verifyEqual(leaseID,id2);
            
            % Finally release this lease as well
            leaseClient2.releaseLease();
        end        


        function testRenew(testCase)
            credentials = configureCredentials(fullfile(AzureCommonRoot,'config','test_ConnectionString.json'));
            blobClient = azure.storage.blob.BlobClientBuilder()...
                .connectionString(credentials)...
                .containerName('leasetest')...
                .blobName('testrenew')...
                .buildClient();

            % Build lease client based on the blob client
            leaseClient = azure.storage.blob.specialized.BlobLeaseClientBuilder()...
                .blobClient(blobClient).buildClient();

            % Ensure there is no lease from previously failed tests
            try
                leaseClient.breakLease();
            catch ME
                testCase.verifyThat(ME.ExceptionObject.getStatusCode(),...
                    matlab.unittest.constraints.IsEqualTo(404) | ... % Blob may not exist yet
                    matlab.unittest.constraints.IsEqualTo(409) );    % There may be no lease on the blob
            end

            % Upload an example file
            blobClient.uploadFromFile([mfilename('fullpath') '.m'],'overwrite',true);
            % Obtain a lease 
            leaseId = leaseClient.acquireLease(15);

            % Try deleting the file using blobClient without providing
            % leaseid at all, this should fail
            try
                blobClient.deleteBlob();
                testCase.verifyFail;
            catch ME
                testCase.verifyEqual(ME.ExceptionObject.getStatusCode, 412);
                disp 'Delete failed as expected'
            end            
            
            % Wait for 10 seconds
            disp 'Waiting for 10 seconds'
            pause(10)
            
            disp 'Renewing lease'
            leaseClient.renewLease();
            
            % Wait for 10 seconds
            disp 'Waiting for 10 seconds'
            pause(10)
            
            % The original lease should have expired by now but if renew
            % succeeded then it should still be valid and deleting should
            % still be impossible
            try
                blobClient.deleteBlob();
                testCase.verifyFail;
            catch ME
                testCase.verifyEqual(ME.ExceptionObject.getStatusCode, 412);
                disp 'Delete failed as expected'
            end            
            
            % Wait for 10 seconds
            disp 'Waiting for 10 seconds'
            pause(10)
            % Now even the renewed lease should have expired
            blobClient.deleteBlob();


        end


        function testUploadDelete(testCase)
            % Create 2 blob clients
            credentials = configureCredentials(fullfile(AzureCommonRoot,'config','test_ConnectionString.json'));
            blobClient = azure.storage.blob.BlobClientBuilder()...
                .connectionString(credentials)...
                .containerName('leasetest')...
                .blobName('testuploaddelete')...
                .buildClient();
            
            % Build 2 lease clients based on the blob client
            leaseClient1 = azure.storage.blob.specialized.BlobLeaseClientBuilder()...
                .blobClient(blobClient).buildClient();

            leaseClient2 = azure.storage.blob.specialized.BlobLeaseClientBuilder()...
                .blobClient(blobClient).buildClient();

            id1 = leaseClient1.getLeaseId();
            id2 = leaseClient2.getLeaseId();
            testCase.verifyNotEqual(id1,id2)

            % Ensure there is no lease from previously failed tests
            try
                leaseClient1.breakLease();
            catch ME
                testCase.verifyThat(ME.ExceptionObject.getStatusCode(),...
                    matlab.unittest.constraints.IsEqualTo(404) | ... % Blob may not exist yet
                    matlab.unittest.constraints.IsEqualTo(409) );    % There may be no lease on the blob
            end

            % Upload an example file
            blobClient.uploadFromFile([mfilename('fullpath') '.m'],'overwrite',true);
            % Obtain a lease using client 1
            leaseId = leaseClient1.acquireLease(-1);
            testCase.verifyEqual(leaseId,id1);
            
            % Try deleting the file using blobClient without providing
            % leaseid at all, this should fail
            try
                blobClient.deleteBlob();
                testCase.verifyFail;
            catch ME
                testCase.verifyEqual(ME.ExceptionObject.getStatusCode, 412);
                disp 'Delete failed as expected'
            end

            % Try deleting the file using blobClient with providing other
            % leaseid, this should fail
            try
                blobClient.deleteBlob('leaseid',id2);
                testCase.verifyFail;
            catch  ME
                testCase.verifyEqual(ME.ExceptionObject.getStatusCode, 412);
                disp 'Delete failed as expected'
            end

            % Verify that the file *can* be deleted when providing the
            % correct leaseid
            blobClient.deleteBlob('leaseid',leaseId);

            testCase.verifyFalse(blobClient.exists());
        end

        function testCopyFromUrl(testCase)
            credentials = configureCredentials(fullfile(AzureCommonRoot,'config','test_ConnectionString.json'));
            srcClient = azure.storage.blob.BlobClientBuilder()...
                .connectionString(credentials)...
                .containerName('leasetest')...
                .blobName('testcopyfromurlsource')...
                .buildClient();

            dstClient = azure.storage.blob.BlobClientBuilder()...
                .connectionString(credentials)...
                .containerName('leasetest')...
                .blobName('testcopyfromurldestination')...
                .buildClient();

            leaseClient = azure.storage.blob.specialized.BlobLeaseClientBuilder()...
                .blobClient(dstClient).buildClient();

            % Upload source
            srcClient.uploadFromFile([mfilename('fullpath') '.m'],'overwrite',true);
            % Get URL for source
            permissions = azure.storage.blob.sas.BlobSasPermission();
            permissions = permissions.setReadPermission(true);
            expiryTime = datetime('now', 'TimeZone', 'UTC') + days(1);
            sasValues = azure.storage.blob.sas.BlobServiceSasSignatureValues(expiryTime, permissions);
            srcUrl = srcClient.getBlobUrl();
            srcSas = srcClient.generateSas(sasValues);
            srcStr = append(srcUrl, '?', srcSas);

            % Ensure there is no lease from previously failed tests
            try
                leaseClient.breakLease();
            catch ME
                testCase.verifyThat(ME.ExceptionObject.getStatusCode(),...
                    matlab.unittest.constraints.IsEqualTo(404) | ... % Blob may not exist yet
                    matlab.unittest.constraints.IsEqualTo(409) );    % There may be no lease on the blob
            end

            % Ensure the destination exists otherwise we cannot put a lease
            % on it
            dstClient.uploadFromFile([mfilename('fullpath') '.m'],'overwrite',true);

            % Put a lease on it
            leaseId = leaseClient.acquireLease(-1);
            
            % Try to create/overwrite using copyFromUrl without leaseId,
            % should fail
            try
                dstClient.copyFromUrl(srcStr);
            catch ME
                testCase.verifyEqual(ME.ExceptionObject.getStatusCode, 412);
                disp 'copyFromUrl failed as expected'                
            end
            dstClient.copyFromUrl(srcStr,'leaseid',leaseId);
            % Now with leaseId, should succeed
            
            % Clean-up
            leaseClient.releaseLease();
            dstClient.deleteBlob();

        end


        function testContainerDelete(testCase)
            containerName = "unittestcontainer-" + char(java.util.UUID.randomUUID);

            credentials = configureCredentials(fullfile(AzureCommonRoot,'config','test_ConnectionString.json'));
            containerClient = azure.storage.blob.BlobContainerClientBuilder()...
                .connectionString(credentials)...
                .containerName(containerName)...
                .buildClient();

            % Build lease client based on the container client
            builder = azure.storage.blob.specialized.BlobLeaseClientBuilder;
            builder = builder.containerClient(containerClient);
            leaseClient = builder.buildClient();

            % Create the container
            containerClient.create();

            % Put on a lease
            leaseId = leaseClient.acquireLease(-1);
            
            % Try deleting the container without leaseId, this should fail
            try
                containerClient.deleteContainer();
                testCase.verifyFail;
            catch ME
                testCase.verifyEqual(ME.ExceptionObject.getStatusCode, 412);
                disp 'Delete failed as expected'
            end
            
            % Delete it with leaseId
            containerClient.deleteContainer('leaseid',leaseId);

        end

    end
end