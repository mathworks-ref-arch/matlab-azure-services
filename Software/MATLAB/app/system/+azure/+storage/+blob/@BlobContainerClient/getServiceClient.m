function serviceClient = getServiceClient(obj)
% GETSERVICECLIENT Get a client pointing to the account.

% Copyright 2022 The MathWorks, Inc.

serviceClient = azure.storage.blob.BlobServiceClient(obj.Handle.getServiceClient());

end