function keyVaultSecret = getSecret(obj, secretName)
% GETSECRETS Returns the secret value of the specific secret by name
% The name can be provided as a scalar character vector or string.
% An exception is thrown is a secret does not exist otherwise a
% azure.security.keyvault.secrets.models.KeyVaultSecret is returned.
%
% Example
%     secret = secretClient.getsecret('mySecretName');


% Copyright 2020-2021 The MathWorks, Inc.

if ~(ischar(secretName) || isStringScalar(secretName))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected secretName to be of type character vector or scalar string');
end

keyVaultSecretj = obj.Handle.getSecret(secretName);
keyVaultSecret = azure.security.keyvault.secrets.models.KeyVaultSecret(keyVaultSecretj);
    
end