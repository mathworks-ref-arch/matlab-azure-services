function client = buildClient(obj)
% BUILDCLIENT Creates a BlobClient based on options set in the builder
% A built BlobClient object is returned.

% Copyright 2020 The MathWorks, Inc.

clientj = obj.Handle.buildClient();
client = azure.storage.blob.BlobClient(clientj);

end