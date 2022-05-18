function queueMessageItem = receiveMessage(obj)
% RECEIVEMESSAGE Retrieves the first message in the queue
% The message is hidden from other operations for 30 seconds.
% If no message is found an empty double is returned.

% Copyright 2021 The MathWorks, Inc.

queueMessageItemj = obj.Handle.receiveMessage();
if isempty(queueMessageItemj)
    queueMessageItem = [];
else
    queueMessageItem = azure.storage.queue.models.QueueMessageItem(queueMessageItemj);
end

end