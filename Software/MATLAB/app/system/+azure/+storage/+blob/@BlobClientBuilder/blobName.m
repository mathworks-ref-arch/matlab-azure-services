function builder = blobName(obj, blobName)
% BLOBNAME Sets the name of the blob
% blobName should be of type character vector or scalar string.
% An updated builder object is returned.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(blobName) || isStringScalar(blobName))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid blobName argument');
else
    builderj = obj.Handle.blobName(blobName);
    builder = azure.storage.blob.BlobClientBuilder(builderj);
end

end