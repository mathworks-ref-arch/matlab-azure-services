function key = getKey(obj)
% GETKEY Get the public part of the latest version of the key
% A azure.security.keyvault.keys.models.JsonWebKey is returned
%
% Example:
%     jsonWebKey = key.getKey();

% Copyright 2021 The MathWorks, Inc.

keyj = obj.Handle.getKey();
key = azure.security.keyvault.keys.models.JsonWebKey(keyj);

end
