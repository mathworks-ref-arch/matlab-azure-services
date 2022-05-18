function secretProperties = listPropertiesOfSecrets(obj)
% LISTPROPERTIESOFSECRETS Lists secrets in the key vault
% Properties are returned as an array of 
% azure.security.keyvault.secrets.models.SecretProperties objects.
% If there are no secrets an empty array is returned.
%
% Example:
%     % Get a list the secret properties
%     secretProperties = secretClient.listPropertiesOfSecrets();
%     % Look at some of the data returned i.e. the secret name
%     propList(1).getName();

% Copyright 2020-2021 The MathWorks, Inc.

secretProperties = azure.security.keyvault.secrets.models.SecretProperties.empty;

pagedIter = obj.Handle.listPropertiesOfSecrets();
iterator = pagedIter.iterator();
while iterator.hasNext()
    secretPropertyj = iterator.next();
    secretProperty = azure.security.keyvault.secrets.models.SecretProperties(secretPropertyj);
    secretProperties(end+1) = secretProperty; %#ok<AGROW>
end

end