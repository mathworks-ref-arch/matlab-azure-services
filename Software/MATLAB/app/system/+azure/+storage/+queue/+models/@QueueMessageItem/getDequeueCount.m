function count = getDequeueCount(obj)
% GETDEQUEUECOUNT Get the number of times the message has been dequeued
% An int64 is returned.

% Copyright 2021 The MathWorks, Inc.

countj = obj.Handle.getDequeueCount();
count = int64(countj);

end
