function queueMessageItem = setMessageId(obj, messageId)
% SETMESSAGEID Set the messageId property
% The messageId may be of type character vector or scalar string
% A QueueMessageItem is returned.

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(messageId) || isStringScalar(messageId))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid messageId argument');
end

queueMessageItemj = obj.Handle.setMessageId(messageId);
queueMessageItem = azure.storage.queue.models.QueueMessageItem(queueMessageItemj);

end
