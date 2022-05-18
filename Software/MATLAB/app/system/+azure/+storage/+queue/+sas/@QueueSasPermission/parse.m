function queueSasPermission = parse(permString)
% PARSE Creates a QueueSasPermission from the specified permissions string
% A azure.storage.queue.sas.QueueSasPermission object is returned.
% permString should be of type scalar string or character vector.
% Throws an IllegalArgumentException if it encounters a character that does
% not correspond to a valid permission.
% This is a static method.
% Expected characters are r, a, u, or p.

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(permString) || isStringScalar(permString))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid permString argument');
end

queueSasPermissionj = com.azure.storage.queue.sas.QueueSasPermission.parse(permString);
queueSasPermission = azure.storage.queue.sas.QueueSasPermission(queueSasPermissionj);

end