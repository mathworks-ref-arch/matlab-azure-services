function builder = credential(obj, credential)
% CREDENTIAL Sets the credential used to authorize requests
% Credential argument should be of type azure.storage.common.StorageSharedKeyCredential
% or azure.core.credential.TokenCredential.
% An updated builder object is returned.

% Copyright 2022 The MathWorks, Inc.

if isa(credential, 'azure.storage.common.StorageSharedKeyCredential') || ...
    isa(credential, 'azure.core.credential.TokenCredential')
    builderj = obj.Handle.credential(credential.Handle);
    builder = azure.storage.file.datalake.DataLakeFileSystemClientBuilder(builderj);
else
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid credential argument');
end

end