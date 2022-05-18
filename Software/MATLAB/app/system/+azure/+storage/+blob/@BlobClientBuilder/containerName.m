function builder = containerName(obj, containerName)
% CONTAINERNAME Sets the name of the container that contains the blob
% containerName should be of type character vector or scalar string.
% An updated builder object is returned.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(containerName) || isStringScalar(containerName))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid containerName argument');
else
    builderj = obj.Handle.containerName(containerName);
    builder = azure.storage.blob.BlobClientBuilder(builderj);
end

end