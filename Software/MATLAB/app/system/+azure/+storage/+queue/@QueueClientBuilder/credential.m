function builder = credential(obj, credential)
% CREDENTIAL Sets the credential used to authorize requests
% Credential argument should be of type azure.storage.common.StorageSharedKeyCredential.
% An updated builder object is returned.

% Copyright 2021 The MathWorks, Inc.

if isa(credential, 'azure.storage.common.StorageSharedKeyCredential') || ...
    isa(credential, 'azure.core.credential.TokenCredential')
    builderj = obj.Handle.credential(credential.Handle);
    builder = azure.storage.queue.QueueClientBuilder(builderj);
else
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid credential argument');
end

end