function tf = hasTableAccess(obj)
% HASTABLEACCESS Returns the access status for table resources
% The result is returned as a logical

% Copyright 2020 The MathWorks, Inc.

tf = obj.Handle.hasTableAccess();

end
