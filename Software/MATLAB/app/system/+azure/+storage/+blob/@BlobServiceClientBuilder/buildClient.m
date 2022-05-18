function client = buildClient(obj)
% BUILDCLIENT Creates a BlobServiceClient based on options set in the builder
% A built BlobServiceClient object is returned.

% Copyright 2020 The MathWorks, Inc.

clientj = obj.Handle.buildClient();
client = azure.storage.blob.BlobServiceClient(clientj);

end