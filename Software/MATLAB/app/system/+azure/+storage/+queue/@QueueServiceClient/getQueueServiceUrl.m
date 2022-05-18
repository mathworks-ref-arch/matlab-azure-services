function url = getQueueServiceUrl(obj)
% GETQUEUESERVICEURL Gets the URL of the storage queue

% Copyright 2021 The MathWorks, Inc.

url = char(obj.Handle.getQueueServiceUrl());

end