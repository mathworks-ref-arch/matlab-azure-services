function blobSasPermission = setAddPermission(obj, permission)
% SETADDPERMISSION Sets the add permission status
% The permission argument should be of type logical.
% A azure.storage.blob.sas.BlobSasPermission object is returned.

% Copyright 2020 The MathWorks, Inc.

if ~islogical(permission)
    logObj = Logger.getLogger();
    write(logObj,'error','permission argument must be of type logical');
end

blobSasPermissionj = obj.Handle.setAddPermission(permission);
blobSasPermission = azure.storage.blob.sas.BlobSasPermission(blobSasPermissionj);

end
