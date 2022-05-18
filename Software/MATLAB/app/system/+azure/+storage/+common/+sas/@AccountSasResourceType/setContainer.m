function accountSasResourceType = setContainer(obj, container)
% SETCONTAINER Sets the access status for container level APIs
% Grants access to Blob Containers, Tables, Queues, and File Shares.
% The container argument should be of type logical.
% A azure.storage.common.sas.AccountSasResourceType object is returned.

% Copyright 2020 The MathWorks, Inc.

if ~islogical(container)
    logObj = Logger.getLogger();
    write(logObj,'error','container argument must be of type logical');
end

accountSasResourceTypej = obj.Handle.setContainer(container);
accountSasResourceType = azure.storage.common.sas.AccountSasResourceType(accountSasResourceTypej);

end
