function sas = generateUserDelegationSas(obj, blobServiceSasSignatureValues, userDelegationKey)
% GENERATEUSERDELEGATIONSAS Generates a user delegation SAS for the
% container using the specified BlobServiceSasSignatureValues and
% UserDelegationKey. The UserDelegationKey can be obtained through the
% getUserDelegationKey method of a BlobServiceClient.
%
% The SAS is returned as a character vector.

% Copyright 2022 The MathWorks, Inc.

if ~isa(blobServiceSasSignatureValues, 'azure.storage.blob.sas.BlobServiceSasSignatureValues') || ...
    ~isa(userDelegationKey, 'azure.storage.blob.models.UserDelegationKey')
    logObj = Logger.getLogger();
    write(logObj,'error','Expected blobServiceSasSignatureValues argument of type azure.storage.blob.sas.BlobServiceSasSignatureValues and userDelegationKey of type azure.storage.blob.models.UserDelegationKey');
end

sas = char(obj.Handle.generateUserDelegationSas(blobServiceSasSignatureValues.Handle,userDelegationKey.Handle));

end