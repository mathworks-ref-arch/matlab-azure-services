function clientId = getClientId(obj)
% GETCLIENTID Gets the client ID of user assigned or system assigned identity
% The client ID is returned as a character vector.

% Copyright 2020-2023 The MathWorks, Inc.

clientId = char(obj.Handle.getClientId);

end