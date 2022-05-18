function str = toString(obj)
% TOSTRING Converts the given permissions to a String
% This method is used to serialize an AccountSasResourceType 
% A character vector is returned.

% Copyright 2020 The MathWorks, Inc.

str = char(obj.Handle.toString());

end
