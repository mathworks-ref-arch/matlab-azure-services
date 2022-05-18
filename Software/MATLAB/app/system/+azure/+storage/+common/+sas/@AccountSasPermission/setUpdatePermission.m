function accountSasPermission = setUpdatePermission(obj, permission)
% SETUPDATEPERMISSION Sets the update permission status
% This allows the update of queue messages and tables.
% The permission argument should be of type logical.
% A azure.storage.common.sas.AccountSasPermission object is returned.

% Copyright 2020 The MathWorks, Inc.

if ~islogical(permission)
    logObj = Logger.getLogger();
    write(logObj,'error','permission argument must be of type logical');
end

accountSasPermissionj = obj.Handle.setUpdatePermission(permission);
accountSasPermission = azure.storage.common.sas.AccountSasPermission(accountSasPermissionj);

end
