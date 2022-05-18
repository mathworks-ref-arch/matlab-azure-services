function builder = sasToken(obj, sasToken)
% sasToken Sets the SAS token used to authorize requests
% sasToken should be of type character vector or scalar string.
% An updated builder object is returned.

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(sasToken) || isStringScalar(sasToken))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid sasToken argument');
else
    builderj = obj.Handle.sasToken(sasToken);
    builder = azure.storage.queue.QueueClientBuilder(builderj);
end

end