function message = peekMessage(obj)
% PEEKMESSAGE Peeks the first message in the queue
% A peek request retrieves a message from the front of the queue without
% changing its visibility. If no message is found an empty double is
% returned.

% Copyright 2021 The MathWorks, Inc.

messageJ = obj.Handle.peekMessage();
if isempty(messageJ)
    message = [];
else
    message = com.azure.storage.queue.models.PeekedMessageItem(messageJ);
end

end
