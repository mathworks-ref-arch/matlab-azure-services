function messageText = getMessageText(obj)
% GETMESSAGETEXT Get the content of the Message
% A character vector is returned.

% Copyright 2021 The MathWorks, Inc.

messageText = char(obj.Handle.getMessageText());

end
