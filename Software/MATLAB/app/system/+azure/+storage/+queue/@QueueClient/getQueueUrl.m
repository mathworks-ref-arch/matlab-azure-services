function queueUrl = getQueueUrl(obj)
% GETQUEUEURL Get associated URL
% A character vector is returned.

% Copyright 2021 The MathWorks, Inc.

queueUrl = char(obj.Handle.getQueueUrl());

end
