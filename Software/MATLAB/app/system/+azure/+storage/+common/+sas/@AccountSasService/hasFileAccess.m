function tf = hasFileAccess(obj)
% HASFILEACCESS Returns the access status for file resources
% The result is returned as a logical

% Copyright 2020 The MathWorks, Inc.

tf = obj.Handle.hasFileAccess();

end
