function result = getName(obj)
% GETNAME Get the key name
% A character vector is returned.

% Copyright 2021 The MathWorks, Inc.

result = char(obj.Handle.getName());

end