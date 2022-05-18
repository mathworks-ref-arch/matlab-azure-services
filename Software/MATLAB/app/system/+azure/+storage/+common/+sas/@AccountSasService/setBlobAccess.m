function accountSasService = setBlobAccess(obj, blob)
% SETBLOBACCESS Sets the access status for blob resources
% The blob argument should be of type logical.
% A azure.storage.common.sas.AccountSasService object is returned.

% Copyright 2020 The MathWorks, Inc.

if ~islogical(blob)
    logObj = Logger.getLogger();
    write(logObj,'error','blob argument must be of type logical');
end

accountSasServicej = obj.Handle.setBlobAccess(blob);
accountSasService = azure.storage.common.sas.AccountSasService(accountSasServicej);

end
