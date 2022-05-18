function name = getName(obj)
% GETNAME Returns the name of the secret
% A character vector is returned.

% Copyright 2020-2021 The MathWorks, Inc.

name = char(obj.Handle.getName());

end