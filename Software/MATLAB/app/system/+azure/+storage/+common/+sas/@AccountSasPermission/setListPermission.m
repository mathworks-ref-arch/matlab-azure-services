function accountSasPermission = setListPermission(obj, permission)
% SETLISTPERMISSION Sets the list permission status
% The permission argument should be of type logical.
% A azure.storage.common.sas.AccountSasPermission object is returned.

% Copyright 2020 The MathWorks, Inc.

if ~islogical(permission)
    logObj = Logger.getLogger();
    write(logObj,'error','permission argument must be of type logical');
end

accountSasPermissionj = obj.Handle.setListPermission(permission);
accountSasPermission = azure.storage.common.sas.AccountSasPermission(accountSasPermissionj);

end
