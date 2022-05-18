function client = buildClient(obj)
% BUILDCLIENT Creates a QueueClient based on options set in the builder
% A built QueueClient object is returned.

% Copyright 2021 The MathWorks, Inc.

clientj = obj.Handle.buildClient();
client = azure.storage.queue.QueueClient(clientj);

end