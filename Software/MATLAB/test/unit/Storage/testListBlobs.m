classdef (SharedTestFixtures={storageFixture}) testListBlobs < matlab.unittest.TestCase
    % testListBlobs Tests blob listing

    % Copyright 2023 The MathWorks, Inc.

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
        function testExists(testCase)
            disp('Running testExists');
            builder = azure.storage.blob.BlobClientBuilder();

            credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
            % ConnectionString should return a credential of type char
            testCase.verifyTrue(ischar(credentials));

            % check for blobs that should exist
            builder = builder.connectionString(credentials);
            builder = builder.httpClient();
            builder = builder.containerName("listtest");
            builder = builder.blobName("foo/foo1");
            client = builder.buildClient();
            testCase.verifyTrue(client.exists());

            builder = builder.blobName("foo/foo2");
            client = builder.buildClient();
            testCase.verifyTrue(client.exists());

            builder = builder.blobName("bar");
            client = builder.buildClient();
            testCase.verifyTrue(client.exists());
        end


        function testBuilderConstructors(testCase)
            disp('Running testBuilderConstructors');
            l = azure.storage.blob.models.ListBlobsOptions();
            b = azure.storage.blob.models.BlobListDetails();
            testCase.verifyNotEmpty(l.Handle);
            testCase.verifyClass(l.Handle, 'com.azure.storage.blob.models.ListBlobsOptions');
            testCase.verifyNotEmpty(b.Handle);
            testCase.verifyClass(b.Handle, 'com.azure.storage.blob.models.BlobListDetails');
        end


        function testlistBlobsByHierarchy(testCase)
            disp('Running testlistBlobsByHierarchy');
            % Create the Client
            builder = azure.storage.blob.BlobContainerClientBuilder();
            credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
            builder = builder.connectionString(credentials);
            builder = builder.httpClient();
            builder = builder.containerName("listtest");
            client = builder.buildClient();

            l = client.listBlobsByHierarchy();
            testCase.verifyNotEmpty(l);
            testCase.verifyEqual(numel(l), 2);
            testCase.verifyEqual(l(1).getName, 'bar');
            testCase.verifyFalse(l(1).isPrefix);
            testCase.verifyEqual(l(2).getName, 'foo/');
            testCase.verifyTrue(l(2).isPrefix);

            l = client.listBlobsByHierarchy("foo");
            testCase.verifyEqual(l(1).getName, 'foo/');
            testCase.verifyTrue(l(1).isPrefix);
            testCase.verifyEqual(numel(l), 1);

            l = client.listBlobsByHierarchy("foo/");
            testCase.verifyEqual(numel(l), 2);
            testCase.verifyEqual(l(1).getName, 'foo/foo1');
            testCase.verifyFalse(l(1).isPrefix);
            testCase.verifyEqual(l(2).getName, 'foo/foo2');
            testCase.verifyFalse(l(2).isPrefix);
        end

        function testBlobListDetailsSetGet(testCase)
            disp('Running testBlobListDetailsSetGet');
            % Test sets and gets
            b = azure.storage.blob.models.BlobListDetails();
            testCase.verifyFalse(b.getRetrieveCopy());
            bnew = b.setRetrieveCopy(true);
            testCase.verifyTrue(bnew.getRetrieveCopy());

            b = azure.storage.blob.models.BlobListDetails();
            testCase.verifyFalse(b.getRetrieveDeletedBlobs());
            bnew = b.setRetrieveDeletedBlobs(true);
            testCase.verifyTrue(bnew.getRetrieveDeletedBlobs());

            b = azure.storage.blob.models.BlobListDetails();
            testCase.verifyFalse(b.getRetrieveDeletedBlobsWithVersions());
            bnew = b.setRetrieveDeletedBlobsWithVersions(true);
            testCase.verifyTrue(bnew.getRetrieveDeletedBlobsWithVersions());

            b = azure.storage.blob.models.BlobListDetails();
            testCase.verifyFalse(b.getRetrieveImmutabilityPolicy());
            bnew = b.setRetrieveImmutabilityPolicy(true);
            testCase.verifyTrue(bnew.getRetrieveImmutabilityPolicy());

            b = azure.storage.blob.models.BlobListDetails();
            testCase.verifyFalse(b.getRetrieveLegalHold());
            bnew = b.setRetrieveLegalHold(true);
            testCase.verifyTrue(bnew.getRetrieveLegalHold());

            b = azure.storage.blob.models.BlobListDetails();
            testCase.verifyFalse(b.getRetrieveMetadata());
            bnew = b.setRetrieveMetadata(true);
            testCase.verifyTrue(bnew.getRetrieveMetadata());

            b = azure.storage.blob.models.BlobListDetails();
            testCase.verifyFalse(b.getRetrieveSnapshots());
            bnew = b.setRetrieveSnapshots(true);
            testCase.verifyTrue(bnew.getRetrieveSnapshots());

            b = azure.storage.blob.models.BlobListDetails();
            testCase.verifyFalse(b.getRetrieveTags());
            bnew = b.setRetrieveTags(true);
            testCase.verifyTrue(bnew.getRetrieveTags());

            b = azure.storage.blob.models.BlobListDetails();
            testCase.verifyFalse(b.getRetrieveUncommittedBlobs());
            bnew = b.setRetrieveUncommittedBlobs(true);
            testCase.verifyTrue(bnew.getRetrieveUncommittedBlobs());

            b = azure.storage.blob.models.BlobListDetails();
            testCase.verifyFalse(b.getRetrieveVersions());
            bnew = b.setRetrieveVersions(true);
            testCase.verifyTrue(bnew.getRetrieveVersions());
        end

        function testListBlobsOptionsSetGet(testCase)
            disp('Running testListBlobsOptionsSetGet');
            % Test sets and gets
            l = azure.storage.blob.models.ListBlobsOptions();
            b = l.getDetails();
            testCase.verifyClass(b, 'azure.storage.blob.models.BlobListDetails');
            testCase.verifyFalse(b.getRetrieveVersions());
            bnew = b.setRetrieveVersions(true);
            lnew = l.setDetails(bnew);
            bnewnew = lnew.getDetails();
            testCase.verifyTrue(bnewnew.getRetrieveVersions());
        end

        function testMaxResultsSetGet(testCase)
            disp('Running testMaxResultsSetGet');
            % Test sets and gets
            l = azure.storage.blob.models.ListBlobsOptions();
            m = l.getMaxResultsPerPage();
            testCase.verifyEmpty(m);
            testCase.verifyClass(m, 'double');
            lnew = l.setMaxResultsPerPage(27);
            mnew = lnew.getMaxResultsPerPage();
            testCase.verifyClass(mnew, 'double');
            testCase.verifyEqual(mnew, 27);
        end

        function testSetGetPrefix(testCase)
            disp('Running testSetGetPrefix');
            % Test sets and gets
            l = azure.storage.blob.models.ListBlobsOptions();
            p = l.getPrefix();
            testCase.verifyEmpty(p);
            testCase.verifyClass(p, 'char');
            
            lnew = l.setPrefix('myCharPrefix');
            p = lnew.getPrefix();
            testCase.verifyClass(p, 'char');
            testCase.verifyEqual(p, 'myCharPrefix');
            
            lnew = l.setPrefix("myStringPrefix");
            p = lnew.getPrefix();
            testCase.verifyClass(p, 'char');
            testCase.verifyEqual(p, 'myStringPrefix');
        end

        function testlistBlobsByHierarchyOptions(testCase)
            disp('Running testlistBlobsByHierarchyOptions');
            % Create the Client
            builder = azure.storage.blob.BlobContainerClientBuilder();
            credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
            builder = builder.connectionString(credentials);
            builder = builder.httpClient();
            builder = builder.containerName("listtest");
            client = builder.buildClient();

            b = azure.storage.blob.models.BlobListDetails();
            b = b.setRetrieveMetadata(true);
            b = b.setRetrieveCopy(true);
            b = b.setRetrieveDeletedBlobs(true);
            % Listing DeletedWithVersions and using a delimiter are mutually exclusive b = b.setRetrieveDeletedBlobsWithVersions(true);
            % b = b.setRetrieveImmutabilityPolicy(true);
            b = b.setRetrieveLegalHold(true);
            % Including snapshots in a hierarchical listing is not supported
            % b = b.setRetrieveSnapshots(true);
            b = b.setRetrieveTags(true);
            b = b.setRetrieveUncommittedBlobs(true);
            % Listing versions and using a delimiter are mutually exclusive.
            % b = b.setRetrieveVersions(true);

            l = azure.storage.blob.models.ListBlobsOptions();
            lnew = l.setDetails(b);
            l = client.listBlobsByHierarchy("/", lnew, 60);
            
            metadata = l(1).getMetadata();
            testCase.verifyClass(metadata, 'containers.Map');
            testCase.verifyTrue(contains(metadata.keys, 'barMetadataKey'));
            testCase.verifyTrue(contains(metadata.values, 'barMetadataVal'));
            testCase.verifyFalse(l(1).isDeleted);
            testCase.verifyFalse(l(1).isPrefix);
            testCase.verifyEqual(l(1).getName, 'bar');
            testCase.verifyEqual(l(1).getSnapshot, '');
            tags = l(1).getTags();
            testCase.verifyClass(tags, 'containers.Map');
            testCase.verifyEqual(l(1).getVersionId, '');

            props = l(1).getProperties;
            testCase.verifyEqual(props.getCacheControl, '');
            testCase.verifyEqual(props.getContentEncoding, '');
            testCase.verifyEqual(props.getContentLanguage, '')
            testCase.verifyEqual(props.getContentType, 'application/octet-stream')
            testCase.verifyEqual(props.getContentLength, int64(0))
            testCase.verifyClass(props.getContentMd5, 'char');
            testCase.verifyEqual(props.getContentMd5, '1B2M2Y8AsgTpgAmY7PhCfg==');
        end
    end %methods
end %class