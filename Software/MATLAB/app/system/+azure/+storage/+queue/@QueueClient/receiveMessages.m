function queueMessageItems = receiveMessages(obj, varargin)
    % RECEIVEMESSAGES Retrieves up to the maximum number of messages from the queue
    % Messages are hidden from other operations for the timeout period.
    %
    % maxMessages
    %   Maximum number of messages to get.
    %   If there are less messages exist in the queue than requested
    %   all the messages will be returned. If left empty only 1 message
    %   will be retrieved, the allowed range is 1 to 32 messages.
    %
    % visibilityTimeout - Optional.
    %   The timeout period for how long the message is invisible in
    %   the queue. If left empty the received messages will be
    %   invisible for 30 seconds. The timeout must be between 1
    %   second and 7 days.
    %
    % timeout - Optional.
    %   Timeout applied to the operation.
    %   If a response is not returned before the timeout concludes
    %   a RuntimeException will be thrown.
    %
    % context - TODO
    %
    % If a any of visibilityTimeout, timeout or context are provided all must be
    % provided.
    %
    % An array of QueueMessageItem is returned.
    
    % Copyright 2023 The MathWorks, Inc.
    
    p = inputParser;
    p.CaseSensitive = false;
    validSeconds = @(x) isa(x, 'double') || isa(x, 'int32') || isa(x, 'int64') || isduration(x);
    validMaxMessages = @(x) isa(x, 'double') || isa(x, 'int32');
    p.FunctionName = mfilename;
    addParameter(p, 'maxMessages', int32(32), validMaxMessages);
    addParameter(p, 'visibilityTimeout', [], validSeconds);
    addParameter(p, 'timeout', [], validSeconds);
    parse(p,varargin{:});
    
    args = {};

    if ~isempty(p.Results.maxMessages)
        maxMessages = int32(p.Results.maxMessages);
        if maxMessages < 1 || maxMessages > 32
            logObj = Logger.getLogger();
            write(logObj,'error','maxMessages allowed range is 1 to 32');
        else
            args{end+1} = java.lang.Integer(maxMessages);
        end
    else
        args{end+1} = java.lang.Integer(int32(32));
    end
    if ~isempty(p.Results.visibilityTimeout)
        if isduration(p.Results.visibilityTimeout)
            secs = int64(seconds(p.Results.visibilityTimeout));
        else
            secs = int64(visibilityTimeout);
        end
        jd = java.time.Duration.ofSeconds(secs);
        args{end+1} = jd;
    end
    if ~isempty(p.Results.timeout)
        if isduration(p.Results.timeout)
            secs = int64(seconds(p.Results.timeout));
        else
            secs = int64(timeout);
        end
        jd = java.time.Duration.ofSeconds(secs);
        args{end+1} = jd;
    end

    queueMessageItemsJ = obj.Handle.receiveMessages(args{:});

    % Return an array of QueueMessageItems
    queueMessageItems = azure.storage.queue.models.QueueMessageItem.empty;

    % Retrieve the iterator for the object
    pageIterator = queueMessageItemsJ.iterableByPage().iterator();

    while pageIterator.hasNext()
        pagedResponse = pageIterator.next();
        itemsj = pagedResponse.getItems();
        for n = 1:itemsj.size
            queueMessageItemj = itemsj.get(n-1);
            if ~isa(queueMessageItemj, 'com.azure.storage.queue.models.QueueMessageItem')
                logObj = Logger.getLogger();
                write(logObj,'warning','Expected item of type com.azure.storage.queue.models.QueueMessageItem');
            else
                queueMessageItems(end+1) = azure.storage.queue.models.QueueMessageItem(queueMessageItemj); %#ok<AGROW>
            end
        end
    end
end