classdef (SharedTestFixtures={storageFixture}) testCleanupUnitTestContainers < matlab.unittest.TestCase
% TESTBLOBSERVICECLIENT Tests Blob Service Client
% Not a unit test per se but a clean up function to periodically remove left over
% unit test containers that match the unit test naming scheme. Useful in test
% & debug phase.

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
    
    function cleanupUnitTestContainers(testCase)
        disp('Running cleanupUnitTestContainers');
        
        builder = azure.storage.blob.BlobServiceClientBuilder();
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_StorageSharedKey.json'));
        builder = builder.credential(credentials);
        builder = builder.httpClient();
        endpoint = ['https://', credentials.getAccountName(), '.blob.core.windows.net'];
        builder = builder.endpoint(endpoint);
        serviceClient = builder.buildClient();
    
        results = serviceClient.listBlobContainers();
        for n = 1:numel(results)
            if contains(results(n).getName, 'unittestcontainer-')
                disp(['Deleting container: ', results(n).getName]);
                serviceClient.deleteBlobContainer(results(n).getName);
            end
        end

        % report a pass
        testCase.verifyTrue(true);
    end        

end %methods
end %class