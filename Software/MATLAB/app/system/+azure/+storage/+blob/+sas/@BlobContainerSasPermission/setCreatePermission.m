function blobContainerSasPermission = setCreatePermission(obj, permission)
% SETCREATEPERMISSION Sets the create permission status
% The permission argument should be of type logical.
% A azure.storage.blob.sas.BlobContainerSasPermission object is returned.

% Copyright 2020 The MathWorks, Inc.

if ~islogical(permission)
    logObj = Logger.getLogger();
    write(logObj,'error','permission argument must be of type logical');
end

blobContainerSasPermissionj = obj.Handle.setCreatePermission(permission);
blobContainerSasPermission = azure.storage.blob.sas.BlobContainerSasPermission(blobContainerSasPermissionj);

end
