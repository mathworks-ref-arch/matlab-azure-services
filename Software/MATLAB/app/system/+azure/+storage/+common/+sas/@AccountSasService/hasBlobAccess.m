function tf = hasBlobAccess(obj)
% HASBLOBACCESS Returns the access status for blob resources
% The result is returned as a logical

% Copyright 2020 The MathWorks, Inc.

tf = obj.Handle.hasBlobAccess();

end
