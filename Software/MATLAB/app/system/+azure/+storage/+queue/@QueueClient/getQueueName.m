function queueName = getQueueName(obj)
% GETQUEUENAME Get associated account name
% A character vector is returned.

% Copyright 2021 The MathWorks, Inc.

queueName = char(obj.Handle.getQueueName());

end
