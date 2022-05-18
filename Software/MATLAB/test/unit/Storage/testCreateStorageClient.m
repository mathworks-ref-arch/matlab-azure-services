classdef (SharedTestFixtures={storageFixture}) testCreateStorageClient < matlab.unittest.TestCase
    % TESTCREATESTORAGECLIENT Tests createStorageClient convenience
    % function

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


    methods (Test)
        function testClientTypes(testCase)
            client = createStorageClient();
            testCase.verifyClass(client,?azure.storage.blob.BlobServiceClient);

            client = createStorageClient('ContainerName','mycontainer');
            testCase.verifyClass(client,?azure.storage.blob.BlobContainerClient);

            client = createStorageClient('ContainerName','mycontainer','BlobName','myblob');
            testCase.verifyClass(client,?azure.storage.blob.BlobClient);

            client = createStorageClient('Type','QueueService');
            testCase.verifyClass(client,?azure.storage.queue.QueueServiceClient);

            client = createStorageClient('QueueName','myq');
            testCase.verifyClass(client,?azure.storage.queue.QueueClient);

            client = createStorageClient('FileSystemName','mycontainer','ConfigurationFile','test_ClientSecret.json');
            testCase.verifyClass(client,?azure.storage.file.datalake.DataLakeFileSystemClient);

            client = createStorageClient('FileSystemName','mycontainer','FileName','my/file','ConfigurationFile','test_ClientSecret.json');
            testCase.verifyClass(client,?azure.storage.file.datalake.DataLakeFileClient);

            client = createStorageClient('FileSystemName','mycontainer','DirectoryName','my/dir','ConfigurationFile','test_ClientSecret.json');
            testCase.verifyClass(client,?azure.storage.file.datalake.DataLakeDirectoryClient);
            
        end
        
        
    end
end