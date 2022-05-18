function builder = queueName(obj, queueName)
% QUEUENAME Sets the name of the container that contains the queue
% containerName should be of type character vector or scalar string.
% An updated builder object is returned.

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(queueName) || isStringScalar(queueName))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid queueName argument');
else
    builderj = obj.Handle.queueName(queueName);
    builder = azure.storage.queue.QueueClientBuilder(builderj);
end

end