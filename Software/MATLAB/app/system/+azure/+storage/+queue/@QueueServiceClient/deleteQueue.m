function deleteQueue(obj, queueName)
% DELETEQUEUE Deletes a queue in with the specified name

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(queueName) || isStringScalar(queueName))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid queueName argument');
end

obj.Handle.deleteQueue(queueName);

end