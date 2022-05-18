function containerClient = getContainerClient(obj)
% GETCONTAINERCLIENT Gets a client pointing to the parent container.

% Copyright 2022 The MathWorks, Inc.

containerClient = azure.storage.blob.BlobContainerClient(obj.Handle.getContainerClient());

end