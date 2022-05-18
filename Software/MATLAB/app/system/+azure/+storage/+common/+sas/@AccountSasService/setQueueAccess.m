function accountSasService = setQueueAccess(obj, queue)
% SETQUEUEACCESS Sets the access status for queue resources
% The queue argument should be of type logical.
% A azure.storage.common.sas.AccountSasService object is returned.

% Copyright 2020 The MathWorks, Inc.

if ~islogical(queue)
    logObj = Logger.getLogger();
    write(logObj,'error','queue argument must be of type logical');
end

accountSasServicej = obj.Handle.setQueueAccess(queue);
accountSasService = azure.storage.common.sas.AccountSasService(accountSasServicej);

end
