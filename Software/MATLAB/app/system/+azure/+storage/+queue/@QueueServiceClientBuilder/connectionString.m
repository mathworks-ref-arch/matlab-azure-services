function builder = connectionString(obj, connectionString)
% CONNECTIONSTRING Sets the connection string to connect to the service
% connectionString should be of type character vector or scalar string.
% An updated builder object is returned.

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(connectionString) || isStringScalar(connectionString))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid connectionString argument');
else
    builderj = obj.Handle.connectionString(connectionString);
    builder = azure.storage.queue.QueueServiceClientBuilder(builderj);
end

end