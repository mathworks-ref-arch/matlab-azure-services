function scopes = getScopes(obj)
% GETSCOPES Gets the scopes required for the token
% Returns a string array.

% Copyright 2021 The MathWorks, Inc.

listj = obj.Handle.getScopes();
scopes = string(listj.toArray());

end