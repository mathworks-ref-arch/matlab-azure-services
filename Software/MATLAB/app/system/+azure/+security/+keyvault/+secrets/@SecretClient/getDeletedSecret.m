function deletedSecret = getDeletedSecret(obj, secretName)
% GETDELETEDSECRET Gets a secret that has been deleted for a soft-delete enabled key vault.
% The name can be provided as a scalar character vector or string.
% An exception is thrown is a secret does not exist otherwise a
% azure.security.keyvault.secrets.models.DeletedSecret is returned.
%
% Example
%     deletedSecret = secretClient.getDeletedSecret('mySecretName');


% Copyright 2022 The MathWorks, Inc.

if ~(ischar(secretName) || isStringScalar(secretName))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected secretName to be of type character vector or scalar string');
end

deletedSecretj = obj.Handle.getDeletedSecret(secretName);
deletedSecret = azure.security.keyvault.secrets.models.DeletedSecret(deletedSecretj);
    
end
