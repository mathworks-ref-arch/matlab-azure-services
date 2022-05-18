function tf = hasReadPermission(obj)
% HASREADPERMISSION Returns the read permission status
% The result is returned as a logical.
    
% Copyright 2022 The MathWorks, Inc.
    
tf = obj.Handle.hasReadPermission();
    
end
    