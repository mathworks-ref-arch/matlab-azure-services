function str = toString(obj)
% TOSTRING Converts the given permissions to a String
% A character vector is returned.

% Copyright 2022 The MathWorks, Inc.

str = char(obj.Handle.toString());

end
