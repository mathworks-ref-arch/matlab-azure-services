function fileSystemSasPermission = setListPermission(obj, permission)
% SETADDPERMISSION Sets the list permission status
% The permission argument should be of type logical.
% A azure.storage.file.datalake.sas.FileSystemSasPermission object is returned.

% Copyright 2022 The MathWorks, Inc.

if ~islogical(permission)
    logObj = Logger.getLogger();
    write(logObj,'error','permission argument must be of type logical');
end

fileSystemSasPermissionj = obj.Handle.setListPermission(permission);
fileSystemSasPermission = azure.storage.file.datalake.sas.FileSystemSasPermission(fileSystemSasPermissionj);

end
