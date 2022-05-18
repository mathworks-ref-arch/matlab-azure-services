function pathSasPermission = setCreatePermission(obj, permission)
% SETCREATEPERMISSION Sets the create permission status
% The permission argument should be of type logical.
% A azure.storage.file.datalake.sas.PathSasPermission object is returned.

% Copyright 2022 The MathWorks, Inc.

if ~islogical(permission)
    logObj = Logger.getLogger();
    write(logObj,'error','permission argument must be of type logical');
end

pathSasPermissionj = obj.Handle.setCreatePermission(permission);
pathSasPermission = azure.storage.file.datalake.sas.PathSasPermission(pathSasPermissionj);

end
