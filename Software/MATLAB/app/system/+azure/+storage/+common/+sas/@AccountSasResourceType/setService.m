function accountSasResourceType = setService(obj, service)
% SETSERVICE Sets the access status for service level APIs
% The service argument should be of type logical.
% A azure.storage.common.sas.AccountSasResourceType service is returned.

% Copyright 2020 The MathWorks, Inc.

if ~islogical(service)
    logObj = Logger.getLogger();
    write(logObj,'error','service argument must be of type logical');
end

accountSasResourceTypej = obj.Handle.setService(service);
accountSasResourceType = azure.storage.common.sas.AccountSasResourceType(accountSasResourceTypej);

end
