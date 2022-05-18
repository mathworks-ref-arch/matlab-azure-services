function deletedSecrets = listDeletedSecrets(obj)
% LISTDELETEDSECRETS Lists deleted secrets of the key vault if it has
% enabled soft-delete. This operation requires the secrets/list permission.
% Properties are returned as an array of 
% azure.security.keyvault.secrets.models.DeletedSecret objects.
% If there are no secrets an empty array is returned.
%
% Example:
%     % Get a list of the deleted secrets
%     deletedSecrets = secretClient.listDeletedSecrets();
%     % Look at some of the data returned i.e. the secret name
%     deletedSecrets(1).getName();

% Copyright 2022 The MathWorks, Inc.

deletedSecrets = azure.security.keyvault.secrets.models.DeletedSecret.empty;

pagedIter = obj.Handle.listDeletedSecrets();
iterator = pagedIter.iterator();
while iterator.hasNext()
    deletedSecretj = iterator.next();
    deletedSecret = azure.security.keyvault.secrets.models.DeletedSecret(deletedSecretj);
    deletedSecrets(end+1) = deletedSecret; %#ok<AGROW>
end

end