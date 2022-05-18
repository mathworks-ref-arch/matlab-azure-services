function sas = generateSas(obj, blobServiceSasSignatureValues)
% GENERATESAS Generates a SAS for the blob
% The client must be authenticated via StorageSharedKeyCredential
% The SAS is returned as a character vector.

% Copyright 2020 The MathWorks, Inc.

if isa(blobServiceSasSignatureValues, 'azure.storage.blob.sas.BlobServiceSasSignatureValues')
    sas = char(obj.Handle.generateSas(blobServiceSasSignatureValues.Handle));
else
    logObj = Logger.getLogger();
    write(logObj,'error','Expected blobServiceSasSignatureValues argument of type azure.storage.blob.sas.BlobServiceSasSignatureValues');
end

end