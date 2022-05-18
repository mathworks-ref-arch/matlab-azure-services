function queueMessageItem = setPopReceipt(obj, popReceipt)
% SETPOPRECEIPT Set the messageId property
% The popReceipt may be of type character vector or scalar string
% A QueueMessageItem is returned.

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(popReceipt) || isStringScalar(popReceipt))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid popReceipt argument');
end

queueMessageItemj = obj.Handle.setPopReceipt(popReceipt);
queueMessageItem = azure.storage.queue.models.QueueMessageItem(queueMessageItemj);

end
