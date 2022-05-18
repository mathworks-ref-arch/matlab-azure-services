function peekedMessageItem = setMessageId(obj, messageId)
% SETMESSAGEID Set the messageId property
% The messageId may be of type character vector or scalar string
% A PeekedMessageItem is returned.

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(messageId) || isStringScalar(messageId))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid messageId argument');
end

peekedMessageItemj = obj.Handle.setMessageId(messageId);
peekedMessageItem = azure.storage.queue.models.PeekedMessageItem(peekedMessageItemj);

end
