function builder = setAnonymousAccess(obj)
% SETANONYMOUSACCESS Clears the credential used to authorize the request
% An updated builder object is returned.

% Copyright 2020 The MathWorks, Inc.

builderj = obj.Handle.setAnonymousAccess();
builder = azure.storage.blob.BlobContainerClientBuilder(builderj);
end