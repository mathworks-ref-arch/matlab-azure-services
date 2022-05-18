function client = buildClient(obj)
% BUILDCLIENT Creates a BlobContainerClient based on options set in the builder
% A built BlobContainerClient object is returned.

% Copyright 2020 The MathWorks, Inc.

clientj = obj.Handle.buildClient();
client = azure.storage.blob.BlobContainerClient(clientj);

end