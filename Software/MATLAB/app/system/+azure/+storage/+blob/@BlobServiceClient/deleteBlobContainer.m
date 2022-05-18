function deleteBlobContainer(obj, containerName)
% DELETEBLOBCONTAINER Deletes the specified container in the storage account
% The name of the container to create should be passed as a character vector or
% scalar string.

% Copyright 2020 The MathWorks, Inc.

if ischar(containerName) || isStringScalar(containerName)
    obj.Handle.deleteBlobContainer(containerName);
else
    logObj = Logger.getLogger();
    write(logObj,'error','Expected character vector or scalar string argument only');
end


end