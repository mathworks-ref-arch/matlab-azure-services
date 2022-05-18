function key = getKey(obj, name)
% GETKEY Get the public part of the latest version of the specified key
% The name argument is provided as a character vector or scalar string.
% A azure.security.keyvault.keys.models.KeyVaultKey is returned.
%
% Example:
%     key = keyClient.getKey('myKeyName');

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(name) || isStringScalar(name))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected name to be of type character vector or scalar string');
end

keyj = obj.Handle.getKey(name);
key = azure.security.keyvault.keys.models.KeyVaultKey(keyj);

end
    