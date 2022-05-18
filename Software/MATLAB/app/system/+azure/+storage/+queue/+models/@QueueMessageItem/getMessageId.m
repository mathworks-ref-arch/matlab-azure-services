function messageId = getMessageId(obj)
% GETMESSAGEID Get the Id of the Message
% A character vector is returned.

% Copyright 2021 The MathWorks, Inc.

messageId = char(obj.Handle.getMessageId());

end
