function accountSasService = parse(servicesString)
% PARSE Creates an AccountSasService from the specified permissions string
% A azure.storage.common.sas.AccountSasService object is returned.
% servicesString should be of type scalar string or character vector.
% Throws an IllegalArgumentException if it encounters a character that does
% not correspond to a valid service.
% Expected characters are b, f, q, or t.
% This is a static method.

% Copyright 2020 The MathWorks, Inc.


if ~(ischar(servicesString) || isStringScalar(servicesString))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid servicesString argument');
end

accountSasServicej = com.azure.storage.common.sas.AccountSasService.parse(servicesString);
accountSasService = azure.storage.common.sas.AccountSasService(accountSasServicej);

end