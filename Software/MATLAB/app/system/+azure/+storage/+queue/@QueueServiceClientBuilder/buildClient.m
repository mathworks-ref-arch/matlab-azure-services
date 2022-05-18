function client = buildClient(obj)
% BUILDCLIENT Creates a QueueServiceClient based on options set in the builder
% A built QueueServiceClient object is returned.

% Copyright 2021 The MathWorks, Inc.

clientj = obj.Handle.buildClient();
client = azure.storage.queue.QueueServiceClient(clientj);

end