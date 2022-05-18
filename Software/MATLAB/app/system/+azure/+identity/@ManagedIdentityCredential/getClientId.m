function clientId = getClientId(obj)
% GETCLIENTID Gets the client ID of user assigned or system assigned identity
% The accountName is returned as a character vector.

% Copyright 2020 The MathWorks, Inc.

clientId = char(obj.Handle.getClientId);

end