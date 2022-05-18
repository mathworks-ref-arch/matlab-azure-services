function queueClient = createQueue(obj, queueName)
% CREATEQUEUE Creates a queue in with the specified name
% A QueueClient is returned.

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(queueName) || isStringScalar(queueName))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid queueName argument');
end

queueClientj = obj.Handle.createQueue(queueName);
queueClient = azure.storage.queue.QueueClient(queueClientj);

end