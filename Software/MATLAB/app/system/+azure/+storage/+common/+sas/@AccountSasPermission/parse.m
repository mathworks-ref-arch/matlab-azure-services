function accountSasPermission = parse(permString)
% PARSE Creates an AccountSasPermission from the specified permissions string
% A azure.storage.common.sas.AccountSasPermission object is returned.
% permString should be of type scalar string or character vector.
% Throws an IllegalArgumentException if it encounters a character that does
% not correspond to a valid permission.
% This is a static method.
% Expected characters are r, w, d, l, a, c, u, or p.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(permString) || isStringScalar(permString))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid permString argument');
end

accountSasPermissionj = com.azure.storage.common.sas.AccountSasPermission.parse(permString);
accountSasPermission = azure.storage.common.sas.AccountSasPermission(accountSasPermissionj);

end