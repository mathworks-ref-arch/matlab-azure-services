classdef (SharedTestFixtures={storageFixture}) testQueueClient < matlab.unittest.TestCase
% TESTQUEUECLIENT Tests Queue Container Client

% Copyright 2021 The MathWorks, Inc.

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
        % Create the Client
        builder = azure.storage.queue.QueueClientBuilder();
        % Check the Handle
        testCase.verifyNotEmpty(builder.Handle);
        testCase.verifyClass(builder.Handle, 'com.azure.storage.queue.QueueClientBuilder');
    end

    function testBuilderConnectionString(testCase)
        disp('Running testBuilderConnectionString');
        % Create the Client
        builder = azure.storage.queue.QueueClientBuilder();
            
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        % ConnectionString should return a credential of type char
        testCase.verifyTrue(ischar(credentials));
            
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        builder = builder.queueName("unittestqueue-123456");
        client = builder.buildClient();
    
        % Check the Handle
        testCase.verifyNotEmpty(client.Handle);
        testCase.verifyClass(client.Handle, 'com.azure.storage.queue.QueueClient');
    end

    function testClient(testCase)
        disp('Running testClient');
        % create the Client
        initialize('displayLevel', 'verbose', 'loggerPrefix', 'Azure:ADLSG2');
        builder = azure.storage.queue.QueueClientBuilder();
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        builder = builder.queueName("unittestqueue-123456");
        qc = builder.buildClient();
        
        % test getQueueName, getQueueUrl & getAccountName
        qName = qc.getQueueName();
        testCase.verifyTrue(strcmp(qName, 'unittestqueue-123456'));
        qUrl = qc.getQueueUrl();
        testUrl = strcat('https://', qc.getAccountName(), ".queue.core.windows.net/", qName);
        testCase.verifyTrue(strcmp(testUrl, qUrl));

        % Expect to start with an empty q, test clearMessages, peekMessage & receiveMessage
        qc.clearMessages();
%         msg = qc.peekMessage();
%         testCase.verifyEmpty(msg);
%         msg = qc.receiveMessage();
%         testCase.verifyEmpty(msg);

        % Start sending messages, test SendMessageResult methods
        msgResult = qc.sendMessage('my unit test msg');
        receipt = msgResult.getPopReceipt;
        testCase.verifyNotEmpty(receipt);
        testCase.verifyClass(receipt, 'char');
        % check insertion time is within a minute of "now" in UTC
        nowTime = datetime('now', 'TimeZone', 'UTC');
        insertTime = msgResult.getInsertionTime();
        insertDelta = abs(minutes(duration(nowTime - insertTime)));
        testCase.verifyLessThan(insertDelta, 1);
        % Check expiry time is 7 days =/- an hour
        expireTime = msgResult.getExpirationTime();
        expireDelta = abs(hours(duration(expireTime - nowTime)));
        testCase.verifyLessThan(expireDelta, 7*24+1);
        testCase.verifyGreaterThan(expireDelta, 7*24-1);
        % check insertion time and visible time are within 5 seconds
        visibleTime = msgResult.getTimeNextVisible();
        visibleDelta = abs(seconds(duration(visibleTime - insertTime)));
        testCase.verifyLessThan(visibleDelta, 5);
        
        % Allow message to propagate
        pause(5);
        msg = qc.receiveMessage();
        testCase.verifyNotEmpty(msg);
        testCase.verifyClass(msg, 'azure.storage.queue.models.QueueMessageItem');
        count = msg.getDequeueCount();
        testCase.verifyClass(count, 'int64');
        insertTime = msg.getInsertionTime();
        insertDelta = abs(minutes(duration(nowTime - insertTime)));
        testCase.verifyLessThan(insertDelta, 1);
        % Check expiry time is 7 days =/- an hour
        expireTime = msg.getExpirationTime();
        expireDelta = abs(hours(duration(expireTime - nowTime)));
        testCase.verifyLessThan(expireDelta, 7*24+1);
        testCase.verifyGreaterThan(expireDelta, 7*24-1);
        % check insertion time and visble time are within 5 seconds
        visibleTime = msg.getTimeNextVisible();
        visibleDelta = abs(seconds(duration(visibleTime - insertTime)));
        testCase.verifyLessThan(visibleDelta, 40);
        testCase.verifyGreaterThan(visibleDelta, 30);
        
        id = msg.getMessageId();
        testCase.verifyNotEmpty(id);
        testCase.verifyClass(id, 'char');
        text = msg.getMessageText();
        testCase.verifyTrue(strcmp(text, 'my unit test msg'));
        
        receipt = msg.getPopReceipt;
        testCase.verifyNotEmpty(receipt);
        testCase.verifyClass(receipt, 'char');
        
        qc.clearMessages();
%         qc.deleteMessage(id, receipt);
%         msg = qc.receiveMessage();
%         testCase.verifyEmpty(msg);
    end

    function testServiceClient(testCase)
        disp('Running testServiceClient');
        % build service client
        initialize('displayLevel', 'verbose', 'loggerPrefix', 'Azure:ADLSG2');
        builder = azure.storage.queue.QueueServiceClientBuilder();
        credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        builder = builder.connectionString(credentials);
        builder = builder.httpClient();
        qsc = builder.buildClient();
        testCase.verifyClass(qsc, 'azure.storage.queue.QueueServiceClient');
        
        % verify account name
        settings = loadConfigurationSettings(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
        [starti, endi] = regexp(settings.ConnectionString,'AccountName=\w+;');
        nameFromConnStr = settings.ConnectionString(starti+12:endi-1);
        accountName = qsc.getAccountName();
        testCase.verifyTrue(strcmp(accountName, nameFromConnStr));

        % verify url
        url = qsc.getQueueServiceUrl();
        testCase.verifyTrue(strcmp(url, strcat('https://', accountName, '.queue.core.windows.net')));
        
        % verify listQueues
        qList = qsc.listQueues();
        testCase.verifyClass(qList, 'azure.storage.queue.models.QueueItem');
        % expect 1 preexisting entry in the queue
        testCase.verifyGreaterThan(numel(qList), 1);
    end
    
    function testQueueSAS(testCase)
        disp('Running testQueueSAS');
       % create the Client
       builder = azure.storage.queue.QueueClientBuilder();
       credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json'));
       builder = builder.connectionString(credentials);
       builder = builder.httpClient();
       builder = builder.queueName("unittestqueue-123456");
       qc = builder.buildClient();

    end
end

end