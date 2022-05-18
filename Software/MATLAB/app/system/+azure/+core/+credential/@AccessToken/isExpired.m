function tf = isExpired(obj)
% ISEXPIRED Returns a logical if the token has expired or not

% Copyright 2020 The MathWorks, Inc.

tf = obj.Handle.isExpired;

end