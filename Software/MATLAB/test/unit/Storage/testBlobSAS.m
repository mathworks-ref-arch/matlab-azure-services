classdef (SharedTestFixtures={storageFixture}) testBlobSAS < matlab.unittest.TestCase
% TESTBLOBSAS Tests Shared Access Signature code

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

    function BlobSasPermission(testCase)
        bsp = azure.storage.blob.sas.BlobSasPermission();
        % Test constructor
        testCase.verifyFalse(isempty(bsp));
        testCase.verifyClass(bsp.Handle, 'com.azure.storage.blob.sas.BlobSasPermission');

        % All fields should be false
        testCase.verifyFalse(bsp.hasAddPermission());
        testCase.verifyFalse(bsp.hasCreatePermission());
        testCase.verifyFalse(bsp.hasDeletePermission());
        testCase.verifyFalse(bsp.hasReadPermission());
        testCase.verifyFalse(bsp.hasWritePermission());

        % Set each field
        bsp = bsp.setAddPermission(true);
        testCase.verifyTrue(bsp.hasAddPermission());
        bsp = bsp.setAddPermission(false);

        bsp = bsp.setCreatePermission(true);
        testCase.verifyTrue(bsp.hasCreatePermission());
        bsp = bsp.setCreatePermission(false);

        bsp = bsp.setDeletePermission(true);
        testCase.verifyTrue(bsp.hasDeletePermission());
        bsp = bsp.setDeletePermission(false);

        bsp = bsp.setReadPermission(true);
        testCase.verifyTrue(bsp.hasReadPermission());
        bsp = bsp.setReadPermission(false);

        bsp = bsp.setWritePermission(true);
        testCase.verifyTrue(bsp.hasWritePermission());
        bsp = bsp.setWritePermission(false);
    
        % toString and parse back again
        bsp = bsp.setWritePermission(true);
        str = bsp.toString();
        testCase.verifyTrue(ischar(str));
        bspNew = azure.storage.blob.sas.BlobSasPermission.parse(str);
        disp(['String representation is: ', str]);
        testCase.verifyTrue(bspNew.hasWritePermission());
    end

    function BlobContainerSasPermission(testCase)
        bcsp = azure.storage.blob.sas.BlobContainerSasPermission();
        % Test constructor
        testCase.verifyFalse(isempty(bcsp));
        testCase.verifyClass(bcsp.Handle, 'com.azure.storage.blob.sas.BlobContainerSasPermission');
    
        % All fields should be false
        testCase.verifyFalse(bcsp.hasAddPermission());
        testCase.verifyFalse(bcsp.hasCreatePermission());
        testCase.verifyFalse(bcsp.hasDeletePermission());
        testCase.verifyFalse(bcsp.hasListPermission());
        testCase.verifyFalse(bcsp.hasReadPermission());
        testCase.verifyFalse(bcsp.hasWritePermission());
    
        % Set each field
        bcsp = bcsp.setAddPermission(true);
        testCase.verifyTrue(bcsp.hasAddPermission());
        bcsp = bcsp.setAddPermission(false);
    
        bcsp = bcsp.setCreatePermission(true);
        testCase.verifyTrue(bcsp.hasCreatePermission());
        bcsp = bcsp.setCreatePermission(false);
    
        bcsp = bcsp.setDeletePermission(true);
        testCase.verifyTrue(bcsp.hasDeletePermission());
        bcsp = bcsp.setDeletePermission(false);
    
        bcsp = bcsp.setListPermission(true);
        testCase.verifyTrue(bcsp.hasListPermission());
        bcsp = bcsp.setListPermission(false);
    
        bcsp = bcsp.setReadPermission(true);
        testCase.verifyTrue(bcsp.hasReadPermission());
        bcsp = bcsp.setReadPermission(false);
    
        bcsp = bcsp.setWritePermission(true);
        testCase.verifyTrue(bcsp.hasWritePermission());
        bcsp = bcsp.setWritePermission(false);
        
        % toString and parse back again
        bcsp = bcsp.setWritePermission(true);
        str = bcsp.toString();
        testCase.verifyTrue(ischar(str));
        bcspNew = azure.storage.blob.sas.BlobContainerSasPermission.parse(str);
        disp(['String representation is: ', str]);
        testCase.verifyTrue(bcspNew.hasWritePermission());
    end

end %methods
end %class