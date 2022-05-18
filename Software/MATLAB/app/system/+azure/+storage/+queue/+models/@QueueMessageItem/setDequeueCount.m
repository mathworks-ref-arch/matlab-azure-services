function queueMessageItem = setDequeueCount(obj, dequeueCount)
% SETDEQUEUECOUNT Set the DequeueCount property
% The DequeueCount may be of type integer
% A QueueMessageItem is returned.

% Copyright 2021 The MathWorks, Inc.

if ~isinteger(dequeueCount)
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid DequeueCount argument');
end

queueMessageItemj = obj.Handle.setDequeueCount(dequeueCount);
queueMessageItem = azure.storage.queue.models.QueueMessageItem(queueMessageItemj);

end
