function deleteMessage(obj, messageId, popReceipt)
% DELETEMESSAGE Deletes the specified message from the queue
% The messageId and popReceipt arguments should be of type character vector or
% scalar string

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(messageId) || isStringScalar(messageId))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid messageId argument');
end

if ~(ischar(popReceipt) || isStringScalar(popReceipt))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid popReceipt argument');
end

obj.Handle.deleteMessage(messageId, popReceipt);

end
