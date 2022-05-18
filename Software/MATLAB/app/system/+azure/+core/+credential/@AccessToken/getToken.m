function token = getToken(obj)
% GETTOKEN Return token as a character vector.

% Copyright 2020-2021 The MathWorks, Inc.

token = char(obj.Handle.getToken);

end