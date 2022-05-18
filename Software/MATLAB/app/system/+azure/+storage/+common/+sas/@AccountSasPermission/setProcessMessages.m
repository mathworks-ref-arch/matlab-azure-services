function accountSasPermission = setProcessMessages(obj, permission)
% SETPROCESSMESSAGES Sets the process messages permission
% This allows the retrieval and deletion of queue messages.
% The permission argument should be of type logical.
% A azure.storage.common.sas.AccountSasPermission object is returned.

% Copyright 2020 The MathWorks, Inc.

if ~islogical(permission)
    logObj = Logger.getLogger();
    write(logObj,'error','permission argument must be of type logical');
end

accountSasPermissionj = obj.Handle.setProcessMessages(permission);
accountSasPermission = azure.storage.common.sas.AccountSasPermission(accountSasPermissionj);

end
