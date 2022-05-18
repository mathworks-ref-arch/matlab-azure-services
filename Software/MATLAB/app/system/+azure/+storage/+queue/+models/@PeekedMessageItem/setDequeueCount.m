function peekedMessageItem = setDequeueCount(obj, dequeueCount)
% SETDEQUEUECOUNT Set the DequeueCount property
% The DequeueCount may be of type integer
% A PeekedMessageItem is returned.

% Copyright 2021 The MathWorks, Inc.

if ~isinteger(dequeueCount)
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid DequeueCount argument');
end

peekedMessageItemj = obj.Handle.setDequeueCount(dequeueCount);
peekedMessageItem = azure.storage.queue.models.PeekedMessageItem(peekedMessageItemj);

end
