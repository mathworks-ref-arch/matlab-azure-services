function accountSasService = setFileAccess(obj, file)
% SETFILEACCESS Sets the access status for file resources
% The file argument should be of type logical.
% A azure.storage.common.sas.AccountSasService object is returned.

% Copyright 2020 The MathWorks, Inc.

if ~islogical(file)
    logObj = Logger.getLogger();
    write(logObj,'error','file argument must be of type logical');
end

accountSasServicej = obj.Handle.setFileAccess(file);
accountSasService = azure.storage.common.sas.AccountSasService(accountSasServicej);

end
