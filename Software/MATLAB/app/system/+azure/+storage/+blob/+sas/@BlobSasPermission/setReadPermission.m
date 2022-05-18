function blobSasPermission = setReadPermission(obj, permission)
% SETREADPERMISSION Sets the read permission status
% The permission argument should be of type logical.
% A azure.storage.blob.sas.BlobSasPermission object is returned.

% Copyright 2020 The MathWorks, Inc.

if ~islogical(permission)
    logObj = Logger.getLogger();
    write(logObj,'error','permission argument must be of type logical');
end

blobSasPermissionj = obj.Handle.setReadPermission(permission);
blobSasPermission = azure.storage.blob.sas.BlobSasPermission(blobSasPermissionj);

end
