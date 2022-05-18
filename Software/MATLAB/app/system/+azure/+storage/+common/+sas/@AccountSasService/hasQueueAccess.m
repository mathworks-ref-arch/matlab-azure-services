function tf = hasQueueAccess(obj)
% HASQUEUEACCESS Returns the access status for queue resources
% The result is returned as a logical

% Copyright 2020 The MathWorks, Inc.

tf = obj.Handle.hasQueueAccess();

end
