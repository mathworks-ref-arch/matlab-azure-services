function accountSasService = setTableAccess(obj, table)
% SETTABLEACCESS Sets the access status for table resources
% The table argument should be of type logical.
% A azure.storage.common.sas.AccountSasService object is returned.

% Copyright 2020 The MathWorks, Inc.

if ~islogical(table)
    logObj = Logger.getLogger();
    write(logObj,'error','table argument must be of type logical');
end

accountSasServicej = obj.Handle.setTableAccess(table);
accountSasService = azure.storage.common.sas.AccountSasService(accountSasServicej);

end
