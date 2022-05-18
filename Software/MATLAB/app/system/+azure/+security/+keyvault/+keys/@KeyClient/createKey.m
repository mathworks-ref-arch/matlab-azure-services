function keyVaultKey = createKey(obj, keyName, keyType)
% CREATEKEY Creates a new key and stores it in the key vault
% A key name argument is provided as a character vector or scalar string.
% A azure.security.keyvault.keys.models.KeyType is provided as an argument
% to indicate which type of key to create.
% An azure.security.keyvault.keys.models.KeyVaultKey is returned.
%
% Example:
%     % Create a client
%     keyClient = createKeyVaultClient('Type','Key');
%     % Create a key type, in this case RSA
%     rsaKeyType = azure.security.keyvault.keys.models.KeyType.RSA;
%     % Create the key
%     key = KeyClient.createKey('myKeyName', rsaKeyType);

% Copyright 2021 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~(ischar(keyName) || isStringScalar(keyName))
    write(logObj,'error','Expected keyName to be of type character vector or scalar string');
end
if ~isa(keyType, 'azure.security.keyvault.keys.models.KeyType')
    write(logObj,'error','Expected keyType to be of type azure.security.keyvault.keys.models.KeyType');
end

keyVaultKeyj = obj.Handle.createKey(keyName, keyType.toJava);
keyVaultKey = azure.security.keyvault.keys.models.KeyVaultKey(keyVaultKeyj);

end
