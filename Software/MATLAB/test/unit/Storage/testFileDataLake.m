classdef (SharedTestFixtures={storageFixture}) testFileDataLake < matlab.unittest.TestCase
    % TESTFILEDATALAKE Tests DataLake Clients

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

    methods (Static)
        function fileCleanup(fname)
            if exist(fname, 'file') == 2
                disp(['Cleaning up file: ', char(fname)]);
                delete(fname);
            end
        end
    end

    methods (Test)
        function testDataLakeBuilderConstructors(testCase)
            disp('Running testDataLakeBuilderConstructors');
            % Create the Client builder
            builder = azure.storage.file.datalake.DataLakeFileSystemClientBuilder();
            % Check the Handle
            testCase.verifyNotEmpty(builder.Handle);
            testCase.verifyClass(builder.Handle, 'com.azure.storage.file.datalake.DataLakeFileSystemClientBuilder');
            testCase.verifyClass(builder, 'azure.storage.file.datalake.DataLakeFileSystemClientBuilder');

            builder = azure.storage.file.datalake.DataLakePathClientBuilder();
            testCase.verifyNotEmpty(builder.Handle);
            testCase.verifyClass(builder.Handle, 'com.azure.storage.file.datalake.DataLakePathClientBuilder');
            testCase.verifyClass(builder, 'azure.storage.file.datalake.DataLakePathClientBuilder');
        end

        function testFileSystemBuilderStorageSharedKey(testCase)
            disp('Running testFileSystemBuilderStorageSharedKey');

            credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_StorageSharedKey.json'));
            testCase.verifyClass(credentials, 'azure.storage.common.StorageSharedKeyCredential');
            builder = azure.storage.file.datalake.DataLakeFileSystemClientBuilder();
            builder = builder.credential(credentials);
            builder = builder.httpClient();
            endpoint = ['https://', credentials.getAccountName(), '.dfs.core.windows.net'];
            builder = builder.endpoint(endpoint);
            builder = builder.fileSystemName("fdltests");
            client = builder.buildClient();
            testCase.verifyClass(client, 'azure.storage.file.datalake.DataLakeFileSystemClient');
        end

        function testPathSasPermission(testCase)
            disp('Running testPathSasPermission');

            psp = azure.storage.file.datalake.sas.PathSasPermission();
            % Test constructor
            testCase.verifyFalse(isempty(psp));
            testCase.verifyClass(psp.Handle, 'com.azure.storage.file.datalake.sas.PathSasPermission');

            % All fields should be false
            testCase.verifyFalse(psp.hasAddPermission());
            testCase.verifyFalse(psp.hasCreatePermission());
            testCase.verifyFalse(psp.hasDeletePermission());
            testCase.verifyFalse(psp.hasExecutePermission());
            testCase.verifyFalse(psp.hasListPermission());
            testCase.verifyFalse(psp.hasManageAccessControlPermission());
            testCase.verifyFalse(psp.hasManageOwnershipPermission());
            testCase.verifyFalse(psp.hasMovePermission());
            testCase.verifyFalse(psp.hasReadPermission());
            testCase.verifyFalse(psp.hasWritePermission());

            % Set each field
            psp = psp.setAddPermission(true);
            testCase.verifyTrue(psp.hasAddPermission());
            psp = psp.setAddPermission(false);

            psp = psp.setCreatePermission(true);
            testCase.verifyTrue(psp.hasCreatePermission());
            psp = psp.setCreatePermission(false);

            psp = psp.setDeletePermission(true);
            testCase.verifyTrue(psp.hasDeletePermission());
            psp = psp.setDeletePermission(false);

            psp = psp.setListPermission(true);
            testCase.verifyTrue(psp.hasListPermission());
            psp = psp.setListPermission(false);

            psp = psp.setExecutePermission(true);
            testCase.verifyTrue(psp.hasExecutePermission());
            psp = psp.setExecutePermission(false);

            psp = psp.setManageAccessControlPermission(true);
            testCase.verifyTrue(psp.hasManageAccessControlPermission());
            psp = psp.setManageAccessControlPermission(false);

            psp = psp.setManageOwnershipPermission(true);
            testCase.verifyTrue(psp.hasManageOwnershipPermission());
            psp = psp.setManageOwnershipPermission(false);

            psp = psp.setMovePermission(true);
            testCase.verifyTrue(psp.hasMovePermission());
            psp = psp.setMovePermission(false);

            psp = psp.setReadPermission(true);
            testCase.verifyTrue(psp.hasReadPermission());
            psp = psp.setReadPermission(false);

            psp = psp.setWritePermission(true);
            testCase.verifyTrue(psp.hasWritePermission());
            psp = psp.setWritePermission(false);

            % toString and parse back again
            psp = psp.setWritePermission(true);
            str = psp.toString();
            testCase.verifyTrue(ischar(str));
            bspNew = azure.storage.file.datalake.sas.PathSasPermission.parse(str);
            disp(['String representation is: ', str]);
            testCase.verifyTrue(bspNew.hasWritePermission());
        end

        function testFileSystemSasPermission(testCase)
            disp('Running testFileSystemSasPermission');

            fssp = azure.storage.file.datalake.sas.FileSystemSasPermission();
            % Test constructor
            testCase.verifyFalse(isempty(fssp));
            testCase.verifyClass(fssp.Handle, 'com.azure.storage.file.datalake.sas.FileSystemSasPermission');

            % All fields should be false
            testCase.verifyFalse(fssp.hasAddPermission());
            testCase.verifyFalse(fssp.hasCreatePermission());
            testCase.verifyFalse(fssp.hasDeletePermission());
            testCase.verifyFalse(fssp.hasExecutePermission());
            testCase.verifyFalse(fssp.hasListPermission());
            testCase.verifyFalse(fssp.hasManageAccessControlPermission());
            testCase.verifyFalse(fssp.hasManageOwnershipPermission());
            testCase.verifyFalse(fssp.hasMovePermission());
            testCase.verifyFalse(fssp.hasReadPermission());
            testCase.verifyFalse(fssp.hasWritePermission());

            % Set each field
            fssp = fssp.setAddPermission(true);
            testCase.verifyTrue(fssp.hasAddPermission());
            fssp = fssp.setAddPermission(false);

            fssp = fssp.setCreatePermission(true);
            testCase.verifyTrue(fssp.hasCreatePermission());
            fssp = fssp.setCreatePermission(false);

            fssp = fssp.setDeletePermission(true);
            testCase.verifyTrue(fssp.hasDeletePermission());
            fssp = fssp.setDeletePermission(false);

            fssp = fssp.setListPermission(true);
            testCase.verifyTrue(fssp.hasListPermission());
            fssp = fssp.setListPermission(false);

            fssp = fssp.setExecutePermission(true);
            testCase.verifyTrue(fssp.hasExecutePermission());
            fssp = fssp.setExecutePermission(false);

            fssp = fssp.setManageAccessControlPermission(true);
            testCase.verifyTrue(fssp.hasManageAccessControlPermission());
            fssp = fssp.setManageAccessControlPermission(false);

            fssp = fssp.setManageOwnershipPermission(true);
            testCase.verifyTrue(fssp.hasManageOwnershipPermission());
            fssp = fssp.setManageOwnershipPermission(false);

            fssp = fssp.setMovePermission(true);
            testCase.verifyTrue(fssp.hasMovePermission());
            fssp = fssp.setMovePermission(false);

            fssp = fssp.setReadPermission(true);
            testCase.verifyTrue(fssp.hasReadPermission());
            fssp = fssp.setReadPermission(false);

            fssp = fssp.setWritePermission(true);
            testCase.verifyTrue(fssp.hasWritePermission());
            fssp = fssp.setWritePermission(false);

            % toString and parse back again
            fssp = fssp.setWritePermission(true);
            str = fssp.toString();
            testCase.verifyTrue(ischar(str));
            bspNew = azure.storage.file.datalake.sas.FileSystemSasPermission.parse(str);
            disp(['String representation is: ', str]);
            testCase.verifyTrue(bspNew.hasWritePermission());
        end

        function testFileSystemBuilderSAS(testCase)
            disp('Running testFileSystemBuilderSAS');
            
            FSSP = azure.storage.file.datalake.sas.FileSystemSasPermission();
            FSSP = FSSP.setListPermission(true);
            FSSP = FSSP.setReadPermission(true);
            
            expiryTime = datetime('now', 'TimeZone', 'UTC') + days(1);
            DLSSSV = azure.storage.file.datalake.sas.DataLakeServiceSasSignatureValues(expiryTime, FSSP);
            testCase.verifyClass(DLSSSV, 'azure.storage.file.datalake.sas.DataLakeServiceSasSignatureValues');

            % Requires a shared storage key based client for SAS generation
            builder = azure.storage.file.datalake.DataLakeFileSystemClientBuilder();
            credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_StorageSharedKey.json'));
            testCase.verifyClass(credentials, 'azure.storage.common.StorageSharedKeyCredential');
            builder = builder.credential(credentials);
            endpoint = ['https://', credentials.getAccountName(), '.dfs.core.windows.net'];
            builder = builder.endpoint(endpoint);
            builder = builder.httpClient();
            builder = builder.fileSystemName("fdltests");
            client = builder.buildClient();
            testCase.verifyClass(client, 'azure.storage.file.datalake.DataLakeFileSystemClient');
            sasToken = client.generateSas(DLSSSV);

            paths = client.listPaths();
            testCase.verifyNotEmpty(paths);
            testCase.verifyClass(paths(1), 'azure.storage.file.datalake.models.PathItem');

            builder2 = azure.storage.file.datalake.DataLakeFileSystemClientBuilder();
            builder2 = builder2.sasToken(sasToken);
            endpoint = ['https://', credentials.getAccountName(), '.dfs.core.windows.net'];
            builder2 = builder2.endpoint(endpoint);
            builder2 = builder2.httpClient();
            builder2 = builder2.fileSystemName("fdltests");
            client2 = builder2.buildClient();
            testCase.verifyClass(client2, 'azure.storage.file.datalake.DataLakeFileSystemClient');

            paths = client2.listPaths();
            testCase.verifyNotEmpty(paths);
            testCase.verifyClass(paths(1), 'azure.storage.file.datalake.models.PathItem');
        end

        
        function testDataLakeDirectoryClient(testCase)
            disp('Running testDataLakeDirectoryClient');
            builder = azure.storage.file.datalake.DataLakePathClientBuilder();
            credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_StorageSharedKey.json'));
            testCase.verifyClass(credentials, 'azure.storage.common.StorageSharedKeyCredential');
            builder = builder.credential(credentials);
            endpoint = ['https://', credentials.getAccountName(), '.dfs.core.windows.net'];
            builder = builder.endpoint(endpoint);
            builder = builder.httpClient();
            builder = builder.fileSystemName("fdltests");
            builder = builder.pathName('nonExistantDir');
            dirClient = builder.buildDirectoryClient();
            
            testCase.verifyClass(dirClient, 'azure.storage.file.datalake.DataLakeDirectoryClient');
            testCase.verifyFalse(dirClient.exists());

            builder = azure.storage.file.datalake.DataLakeFileSystemClientBuilder();
            credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_StorageSharedKey.json'));
            testCase.verifyClass(credentials, 'azure.storage.common.StorageSharedKeyCredential');
            builder = builder.credential(credentials);
            endpoint = ['https://', credentials.getAccountName(), '.dfs.core.windows.net'];
            builder = builder.endpoint(endpoint);
            builder = builder.httpClient();
            builder = builder.fileSystemName("fdltests");
            fsClient = builder.buildClient();

            % Test createDirectory
            existingDirClient = fsClient.createDirectory('existingDir', true);
            testCase.verifyTrue(existingDirClient.exists());

            % Test getDirectoryPath
            testCase.verifyEqual(existingDirClient.getDirectoryPath(), 'existingDir');
            
            % Test getDirectoryUrl
            uri = existingDirClient.getDirectoryUrl();
            uriStr = strcat(endpoint, '/fdltests/existingDir');
            testCase.verifyEqual(uri.EncodedURI, string(uriStr));
            
            % Test deleteDirectory
            existingDirClient.deleteDirectory();
            testCase.verifyFalse(existingDirClient.exists());
                
            % Test deleteSubdirectory
            level1DirClient = fsClient.createDirectory('level1', true);
            testCase.verifyTrue(level1DirClient.exists());
            level2DirClient = fsClient.createDirectory('level1/level2', true);
            testCase.verifyTrue(level2DirClient.exists());
            level1DirClient.deleteSubdirectory('level2');
            testCase.verifyFalse(level2DirClient.exists());
            
            % Test createFile
            level1DirClient = fsClient.createDirectory('level1', true);
            testCase.verifyTrue(level1DirClient.exists());
            level1FileClient = level1DirClient.createFile('tmpFile.txt', true);
            testCase.verifyTrue(level1FileClient.exists());
            
            % Test Rename
            srcDirClient = fsClient.createDirectory('srcDir', true);
            testCase.verifyTrue(srcDirClient.exists());
            nullVal = [];
            renamedDirClient = srcDirClient.rename(nullVal, 'dstDir');
            testCase.verifyTrue(renamedDirClient.exists());

        end

    end %methods

end %class