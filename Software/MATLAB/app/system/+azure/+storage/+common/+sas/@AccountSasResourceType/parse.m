function accountSasResourceType = parse(resourceTypesString)
% PARSE Creates an AccountSasResourceType from the specified permissions string
% Creates an AccountSasResourceType from the specified resource types string.
% Throws an IllegalArgumentException if passed a character that does not
% correspond to a valid resource type.
% Expected characters are s, c, or o.
% A azure.storage.common.sas.AccountSasResourceType object is returned.
% resourceTypesString should be of type scalar string or character vector.
% This is a static method.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(resourceTypesString) || isStringScalar(resourceTypesString))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid resourceTypesString argument');
end

accountSasResourceTypej = com.azure.storage.common.sas.AccountSasResourceType.parse(resourceTypesString);
accountSasResourceType = azure.storage.common.sas.AccountSasResourceType(accountSasResourceTypej);

end