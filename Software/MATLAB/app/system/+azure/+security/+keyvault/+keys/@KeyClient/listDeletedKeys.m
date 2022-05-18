function deletedKeys = listDeletedKeys(obj)
% LISTDELETEDKEYS Lists deleted keys of the key vault.
% Properties are returned as an array of 
% azure.security.keyvault.keys.models.DeletedKey objects.
% If there are no keys an empty array is returned.
%
% Example
%     % Get a list the key properties
%     deletedKeys = keyClient.listDeletedKeys();


% Copyright 2022 The MathWorks, Inc.

deletedKeys = azure.security.keyvault.keys.models.DeletedKey.empty;

pagedIter = obj.Handle.listDeletedKeys();
iterator = pagedIter.iterator();
while iterator.hasNext()
    deletedKeyj = iterator.next();
    deletedKey = azure.security.keyvault.keys.models.DeletedKey(deletedKeyj);
    deletedKeys(end+1) = deletedKey; %#ok<AGROW>
end


end