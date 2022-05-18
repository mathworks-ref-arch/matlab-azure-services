function accountSasResourceType = setObject(obj, object)
% SETOBJECT Sets the access status for object level APIs
% Grants access to Blobs, Table Entities, Queue Messages, Files.
% The object argument should be of type logical.
% A azure.storage.common.sas.AccountSasResourceType object is returned.

% Copyright 2020 The MathWorks, Inc.

if ~islogical(object)
    logObj = Logger.getLogger();
    write(logObj,'error','object argument must be of type logical');
end

accountSasResourceTypej = obj.Handle.setObject(object);
accountSasResourceType = azure.storage.common.sas.AccountSasResourceType(accountSasResourceTypej);

end
