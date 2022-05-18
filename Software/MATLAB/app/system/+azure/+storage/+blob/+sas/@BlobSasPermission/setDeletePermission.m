function blobSasPermission = setDeletePermission(obj, permission)
% SETDELETEPERMISSION Sets the delete permission status
% The permission argument should be of type logical.
% A azure.storage.blob.sas.BlobSasPermission object is returned.

% Copyright 2020 The MathWorks, Inc.

if ~islogical(permission)
    logObj = Logger.getLogger();
    write(logObj,'error','permission argument must be of type logical');
end

blobSasPermissionj = obj.Handle.setDeletePermission(permission);
blobSasPermission = azure.storage.blob.sas.BlobSasPermission(blobSasPermissionj);

end
