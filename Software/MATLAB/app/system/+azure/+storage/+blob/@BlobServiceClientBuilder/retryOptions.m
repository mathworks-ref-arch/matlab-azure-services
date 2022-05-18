function builder = retryOptions(obj, retryOptions)
% RETRYOPTIONS Sets request retry options for all requests made through the client
% retryOptions may be either a com.azure.storage.common.policy.RequestRetryOptions
% or a azure.storage.common.policy.RequestRetryOptions object.
% An updated azure.storage.blob.BlobServiceClientBuilder object is returned.

% Copyright 2021 The MathWorks, Inc.

if isa(retryOptions, 'com.azure.storage.common.policy.RequestRetryOptions')
    builderj = obj.Handle.retryOptions(retryOptions);
    builder = azure.storage.blob.BlobServiceClientBuilder(builderj);
elseif isa(retryOptions, 'azure.storage.common.policy.RequestRetryOptions')
    builderj = obj.Handle.retryOptions(retryOptions.Handle);
    builder = azure.storage.blob.BlobServiceClientBuilder(builderj);
else
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid retryOptions argument');
end

end