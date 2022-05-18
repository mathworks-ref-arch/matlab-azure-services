function blobContainerClient = createBlobContainer(obj, containerName)
% CREATEBLOBCONTAINER Creates a new container within a storage account
% If a container with the same name already exists, the operation fails.
% The name of the container to create should be passed as a character vector or
% scalar string.
% If the container already exists an empty azure.storage.blob.BlobContainerClient
% is returned otherwise a non empty azure.storage.blob.BlobContainerClient is
% returned.
% In verbose logging mode a message is logged.

% Copyright 2020 The MathWorks, Inc.

if ischar(containerName) || isStringScalar(containerName)
    containerName = char(containerName);
else
    logObj = Logger.getLogger();
    write(logObj,'error','Expected character vector or scalar string argument only');
end

try
    blobContainerClientj = obj.Handle.createBlobContainer(containerName);
    blobContainerClient = azure.storage.blob.BlobContainerClient(blobContainerClientj);
catch e
    if (isa(e,'matlab.exception.JavaException'))
        if contains(e.message, '<Code>ContainerAlreadyExists</Code>')
            logObj = Logger.getLogger();
            write(logObj,'verbose',['Container already exists: ', containerName]);
            blobContainerClient = azure.storage.blob.BlobContainerClient.empty;
        else
            rethrow(e);
        end
    end
end

end