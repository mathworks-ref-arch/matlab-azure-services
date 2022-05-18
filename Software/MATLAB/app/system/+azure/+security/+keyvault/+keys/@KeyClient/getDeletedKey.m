function key = getDeletedKey(obj, name)
% GETDELETEDKEY Gets the public part of a deleted key.
% The name argument is provided as a character vector or scalar string.
% A azure.security.keyvault.keys.models.DeletedKey is returned.
%
% Example:
%     key = keyClient.getDeletedKey('myKeyName');

% Copyright 2022 The MathWorks, Inc.

if ~(ischar(name) || isStringScalar(name))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected name to be of type character vector or scalar string');
end

keyj = obj.Handle.getDeletedKey(name);
key = azure.security.keyvault.keys.models.DeletedKey(keyj);

end
    