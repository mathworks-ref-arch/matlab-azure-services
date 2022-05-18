function count = getApproximateMessageCount(obj)
% GETAPPROXIMATEMESSAGECOUNT Gets the approximate number of messages  in the queue
% Applies at the time of properties retrieval.
% An int64 is returned.

% Copyright 2021 The MathWorks, Inc.

count = int64(obj.Handle.getApproximateMessageCount());

end