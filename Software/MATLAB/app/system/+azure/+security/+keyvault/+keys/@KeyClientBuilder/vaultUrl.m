function builder = vaultUrl(obj, vaultUrl)
% VAULTURL Sets the vault URL to send HTTP requests to
% vaultUrl should be of type character vector or scalar string.
% An updated builder object is returned.
% A URL has the form: https://<myKeyVaultName>.vault.azure.net/
% The vaultUrl can optionally be stored in the package's JSON configuration file.

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(vaultUrl) || isStringScalar(vaultUrl))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid vaultUrl argument');
else
    builderj = obj.Handle.vaultUrl(vaultUrl);
    builder = azure.security.keyvault.keys.KeyClientBuilder(builderj);
end
    
end