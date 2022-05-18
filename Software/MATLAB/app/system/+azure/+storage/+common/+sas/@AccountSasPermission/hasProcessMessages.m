function tf = hasProcessMessages(obj)
% HASPROCESSMESSAGES Returns the process messages permission
% This allows the retrieval and deletion of queue messages.
% The result is returned as a logical.
    
% Copyright 2020 The MathWorks, Inc.
    
tf = obj.Handle.hasProcessMessages();
    
end
    