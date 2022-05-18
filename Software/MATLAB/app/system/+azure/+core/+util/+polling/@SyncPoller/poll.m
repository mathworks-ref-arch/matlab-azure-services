function response = poll(obj)
% POLL Poll once and return the poll response received
% A azure.core.util.polling.PollResponse is returned.

% Copyright 2021 The MathWorks, Inc.   

responsej = obj.Handle.poll();
response = azure.core.util.polling.PollResponse(responsej);

end