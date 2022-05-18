function message = getMessage(obj)
% GETMESSAGE Gets the message which should be displayed to the user.
% Returns a character vector.

% Copyright 2022 The MathWorks, Inc.

message = char(obj.Handle.getMessage());

end