function accountSas = generateAccountSas(obj, accountSasSignatureValues)
% GENERATEACCOUNTSAS Generates an account SAS for the Azure Storage account
% The client must be authenticated via StorageSharedKeyCredential
% The SAS is returned as a character vector.

% Copyright 2020 The MathWorks, Inc.

if isa(accountSasSignatureValues, 'azure.storage.common.sas.AccountSasSignatureValues')
    accountSas = char(obj.Handle.generateAccountSas(accountSasSignatureValues.Handle));
else
    logObj = Logger.getLogger();
    write(logObj,'error','Expected accountSasSignatureValues argument of type azure.storage.common.sas.AccountSasSignatureValues');
end

end