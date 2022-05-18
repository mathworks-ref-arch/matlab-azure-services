function tf = hasUpdatePermission(obj)
% HASUPDATEPERMISSION Returns the update permission status
% The result is returned as a logical
    
% Copyright 2021 The MathWorks, Inc.
    
tf = obj.Handle.hasUpdatePermission();
    
end
    