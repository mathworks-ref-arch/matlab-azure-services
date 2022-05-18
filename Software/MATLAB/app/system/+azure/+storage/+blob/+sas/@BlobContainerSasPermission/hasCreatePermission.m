function tf = hasCreatePermission(obj)
% HASCREATEPERMISSION Returns the create permission status
% The result is returned as a logical
    
% Copyright 2020 The MathWorks, Inc.
    
tf = obj.Handle.hasCreatePermission();
    
end
    