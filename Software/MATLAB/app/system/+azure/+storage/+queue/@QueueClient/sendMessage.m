function sendMessageResult = sendMessage(obj, messageText)
% SENDMESSAGE Sends a message that has a time-to-live of 7 days
% The message is instantly visible.
% A SendMessageResult is returned.

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(messageText) || isStringScalar(messageText))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid messageText argument');
end

sendMessageResultj = obj.Handle.sendMessage(messageText);
sendMessageResult = azure.storage.queue.models.SendMessageResult(sendMessageResultj);

end