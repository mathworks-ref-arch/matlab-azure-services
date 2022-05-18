function tf = hasProcessPermission(obj)
% HASPROCESSPERMISSION Returns the process permission status
% The result is returned as a logical.
    
% Copyright 2021 The MathWorks, Inc.
    
tf = obj.Handle.hasProcessPermission();
    
end
    