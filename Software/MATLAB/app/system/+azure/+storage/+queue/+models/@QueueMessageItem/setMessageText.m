function queueMessageItem = setMessageText(obj, messageText)
% SETMESSAGETEXT Set the messageId property
% The messageText may be of type character vector or scalar string
% A QueueMessageItem is returned.

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(messageText) || isStringScalar(messageText))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid messageText argument');
end

queueMessageItemj = obj.Handle.setMessageText(messageText);
queueMessageItem = azure.storage.queue.models.QueueMessageItem(queueMessageItemj);

end
