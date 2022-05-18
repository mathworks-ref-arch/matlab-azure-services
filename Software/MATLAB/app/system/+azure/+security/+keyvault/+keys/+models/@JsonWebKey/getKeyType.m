function keyType = getKeyType(obj)
% GETKEYTYPE Get the kty value
% A azure.security.keyvault.keys.models.KeyType is returned.

% Copyright 2020-2021 The MathWorks, Inc.

keyTypej = obj.Handle.getKeyType();
keyType = azure.security.keyvault.keys.models.KeyType.fromString(char(keyTypej.toString));

end