function queueClient = getQueueClient(obj, queueName)
% GETQUEUECLIENT Constructs a QueueClient that interacts with the specified queue
% A QueueClient is returned.

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(queueName) || isStringScalar(queueName))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid queueName argument');
end

queueClientj = obj.Handle.getQueueClient(queueName);
queueClient = azure.storage.queue.QueueClient(queueClientj);

end