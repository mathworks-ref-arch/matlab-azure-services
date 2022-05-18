function keyVaultSecret = setSecret(obj, secretName, secretValue)
% SETSECRETS Creates a secrets using a name and value
% This method returns an azure.security.keyvault.secrets.KeyVaultSecret
% object. secretName and secretValue can be provided as character vectors or
% scalar strings.
%
% Example:
%     % Create a SecretClient object
%     sc = createKeyVaultClient('Type','Secret');
%     % Set the secret name and its value to Azure KeyVault
%     keyVaultSecret = sc.setSecret(secretName, secretValue);

% Copyright 2020-2021 The MathWorks, Inc.

if ~(ischar(secretName) || isStringScalar(secretName))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected secretName to be of type character vector or scalar string');
end

if ~(ischar(secretValue) || isStringScalar(secretValue))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected secretValue to be of type character vector or scalar string');
end

keyVaultSecretj = obj.Handle.setSecret(secretName, secretValue);
keyVaultSecret = azure.security.keyvault.secrets.models.KeyVaultSecret(keyVaultSecretj);

end