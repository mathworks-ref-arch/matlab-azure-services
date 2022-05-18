function keyProperties = listPropertiesOfKeys(obj)
% LISTPROPERTIESOFKEYS Lists keys in the key vault
% Properties are returned as an array of 
% azure.security.keyvault.keys.models.KeyProperties objects.
% If there are no keys an empty array is returned.
%
% Example
%     % Get a list the key properties
%     keyProperties = keyClient.listPropertiesOfKeys();
%     % Look at some of the data returned i.e. the key name
%     propList(1).getName();

% Copyright 2021 The MathWorks, Inc.

keyProperties = azure.security.keyvault.keys.models.KeyProperties.empty;

pagedIter = obj.Handle.listPropertiesOfKeys();
iterator = pagedIter.iterator();
while iterator.hasNext()
    keyPropertyj = iterator.next();
    keyProperty = azure.security.keyvault.keys.models.KeyProperties(keyPropertyj);
    keyProperties(end+1) = keyProperty; %#ok<AGROW>
end

end