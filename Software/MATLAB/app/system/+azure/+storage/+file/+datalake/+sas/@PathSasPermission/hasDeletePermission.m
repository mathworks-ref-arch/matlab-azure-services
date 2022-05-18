function tf = hasDeletePermission(obj)
% HASDELETEPERMISSION Returns the delete permission status
% The result is returned as a logical.
    
% Copyright 2022 The MathWorks, Inc.
    
tf = obj.Handle.hasDeletePermission();
    
end
    