function blobSasPermission = parse(permString)
% PARSE Creates a BlobSasPermission from the specified permissions string
% A azure.storage.blob.sas.BlobSasPermission object is returned.
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

blobSasPermissionj = com.azure.storage.blob.sas.BlobSasPermission.parse(permString);
blobSasPermission = azure.storage.blob.sas.BlobSasPermission(blobSasPermissionj);

end