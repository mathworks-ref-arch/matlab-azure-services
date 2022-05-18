function fileSystemSasPermission = parse(permString)
% PARSE Creates a FileSystemSasPermission from the specified permissions string
% A azure.storage.file.datalake.sas.FileSystemPermission object is returned.
% permString should be of type scalar string or character vector.
% Throws an IllegalArgumentException if it encounters a character that does
% not correspond to a valid permission.
% This is a static method.

% Copyright 2022 The MathWorks, Inc.

if ~(ischar(permString) || isStringScalar(permString))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid permString argument');
end

fileSystemSasPermissionj = com.azure.storage.file.datalake.sas.FileSystemSasPermission.parse(permString);
fileSystemSasPermission = azure.storage.file.datalake.sas.FileSystemSasPermission(fileSystemSasPermissionj);

end