function peekedMessageItem = setMessageText(obj, messageText)
% SETMESSAGETEXT Set the messageId property
% The messageText may be of type character vector or scalar string
% A PeekedMessageItem is returned.

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(messageText) || isStringScalar(messageText))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid messageText argument');
end

peekedMessageItemj = obj.Handle.setMessageText(messageText);
peekedMessageItem = azure.storage.queue.models.PeekedMessageItem(peekedMessageItemj);

end
