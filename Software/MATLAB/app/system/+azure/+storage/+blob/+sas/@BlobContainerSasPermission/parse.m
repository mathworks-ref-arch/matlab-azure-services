function blobContainerSasPermission = parse(permString)
% PARSE Creates a BlobContainerSasPermission from the specified permissions string
% A azure.storage.blob.sas.BlobContainerSasPermission object is returned.
% permString should be of type scalar string or character vector.
% Throws an IllegalArgumentException if it encounters a character that does
% not correspond to a valid permission.
% This is a static method.
% Expected characters are r, a, c, w, or d.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(permString) || isStringScalar(permString))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid permString argument');
end

blobContainerSasPermissionj = com.azure.storage.blob.sas.BlobContainerSasPermission.parse(permString);
blobContainerSasPermission = azure.storage.blob.sas.BlobContainerSasPermission(blobContainerSasPermissionj);

end