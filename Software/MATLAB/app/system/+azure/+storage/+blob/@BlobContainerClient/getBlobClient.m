function blobClient = getBlobClient(obj, blobName)
% GETBLOBCLIENT Initializes a new BlobClient object 
% blobName should be a scalar string or character vector.
% A BlobClient is returned.

% Copyright 2020 The MathWorks, Inc.

if ischar(blobName) || isStringScalar(blobName)  
    blobClientj = obj.Handle.getBlobClient(blobName);
    blobClient = azure.storage.blob.BlobClient(blobClientj);
else
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid argument(s)');
end

end