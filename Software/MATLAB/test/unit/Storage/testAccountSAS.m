classdef (SharedTestFixtures={storageFixture}) testAccountSAS < matlab.unittest.TestCase
% TESTACCOUNTSAS Tests Shared Access Signature code

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
    function testAccountSasResourceType(testCase)
        srt = azure.storage.common.sas.AccountSasResourceType();
        % Test constructor
        testCase.verifyFalse(isempty(srt));
        testCase.verifyClass(srt.Handle, 'com.azure.storage.common.sas.AccountSasResourceType');

        % All fields should be false
        testCase.verifyFalse(srt.isObject());
        testCase.verifyFalse(srt.isContainer());
        testCase.verifyFalse(srt.isService());

        % Set each field
        srt = srt.setContainer(true);
        testCase.verifyTrue(srt.isContainer());
        srt = srt.setContainer(false);
        testCase.verifyFalse(srt.isContainer());

        srt = srt.setObject(true);
        testCase.verifyTrue(srt.isObject());
        srt = srt.setObject(false);
        testCase.verifyFalse(srt.isObject());

        srt = srt.setService(true);
        testCase.verifyTrue(srt.isService());
        srt = srt.setService(false);
        testCase.verifyFalse(srt.isService());
    
        % toString and parse back again
        srt = srt.setContainer(true);
        str = srt.toString();
        testCase.verifyTrue(ischar(str));
        srtNew = azure.storage.common.sas.AccountSasResourceType.parse(str);
        disp(['String representation is: ', str]);
        testCase.verifyTrue(srtNew.isContainer());
    end


    function testAccountSasService(testCase)
        ass = azure.storage.common.sas.AccountSasService();
        % Test constructor
        testCase.verifyFalse(isempty(ass));
        testCase.verifyClass(ass.Handle, 'com.azure.storage.common.sas.AccountSasService');

        % All fields should be false
        testCase.verifyFalse(ass.hasBlobAccess());
        testCase.verifyFalse(ass.hasFileAccess());
        testCase.verifyFalse(ass.hasQueueAccess());
        testCase.verifyFalse(ass.hasTableAccess());

        % Set each field
        ass = ass.setBlobAccess(true);
        testCase.verifyTrue(ass.hasBlobAccess());
        ass = ass.setBlobAccess(false);

        ass = ass.setFileAccess(true);
        testCase.verifyTrue(ass.hasFileAccess());
        ass = ass.setFileAccess(false);

        ass = ass.setQueueAccess(true);
        testCase.verifyTrue(ass.hasQueueAccess());
        ass = ass.setQueueAccess(false);

        ass = ass.setTableAccess(true);
        testCase.verifyTrue(ass.hasTableAccess());
        ass = ass.setTableAccess(false);

        % toString and parse back again
        ass = ass.setBlobAccess(true);
        str = ass.toString();
        testCase.verifyTrue(ischar(str));
        assNew = azure.storage.common.sas.AccountSasService.parse(str);
        disp(['String representation is: ', str]);
        testCase.verifyTrue(assNew.hasBlobAccess());
    end


    function AccountSasPermission(testCase)
        asp = azure.storage.common.sas.AccountSasPermission();
        % Test constructor
        testCase.verifyFalse(isempty(asp));
        testCase.verifyClass(asp.Handle, 'com.azure.storage.common.sas.AccountSasPermission');

        % All fields should be false
        testCase.verifyFalse(asp.hasAddPermission());
        testCase.verifyFalse(asp.hasCreatePermission());
        testCase.verifyFalse(asp.hasDeletePermission());
        testCase.verifyFalse(asp.hasListPermission());
        testCase.verifyFalse(asp.hasProcessMessages());
        testCase.verifyFalse(asp.hasReadPermission());
        testCase.verifyFalse(asp.hasUpdatePermission());
        testCase.verifyFalse(asp.hasWritePermission());

        % Set each field
        asp = asp.setAddPermission(true);
        testCase.verifyTrue(asp.hasAddPermission());
        asp = asp.setAddPermission(false);

        asp = asp.setCreatePermission(true);
        testCase.verifyTrue(asp.hasCreatePermission());
        asp = asp.setCreatePermission(false);

        asp = asp.setDeletePermission(true);
        testCase.verifyTrue(asp.hasDeletePermission());
        asp = asp.setDeletePermission(false);

        asp = asp.setListPermission(true);
        testCase.verifyTrue(asp.hasListPermission());
        asp = asp.setListPermission(false);

        asp = asp.setProcessMessages(true);
        testCase.verifyTrue(asp.hasProcessMessages());
        asp = asp.setProcessMessages(false);

        asp = asp.setReadPermission(true);
        testCase.verifyTrue(asp.hasReadPermission());
        asp = asp.setReadPermission(false);

        asp = asp.setUpdatePermission(true);
        testCase.verifyTrue(asp.hasUpdatePermission());
        asp = asp.setUpdatePermission(false);

        asp = asp.setWritePermission(true);
        testCase.verifyTrue(asp.hasWritePermission());
        asp = asp.setWritePermission(false);
    
        % toString and parse back again
        asp = asp.setWritePermission(true);
        str = asp.toString();
        testCase.verifyTrue(ischar(str));
        aspNew = azure.storage.common.sas.AccountSasPermission.parse(str);
        disp(['String representation is: ', str]);
        testCase.verifyTrue(aspNew.hasWritePermission());
    end
end %methods
end %class