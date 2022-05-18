function tf = hasListPermission(obj)
% HASLISTPERMISSION Returns the list permission status
% The result is returned as a logical.
    
% Copyright 2020 The MathWorks, Inc.
    
tf = obj.Handle.hasListPermission();
    
end
    