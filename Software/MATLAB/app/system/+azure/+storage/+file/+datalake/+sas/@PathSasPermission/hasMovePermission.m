function tf = hasMovePermission(obj)
% HASMOVEPERMISSION Returns the move permission status
% The result is returned as a logical.
    
% Copyright 2022 The MathWorks, Inc.
    
tf = obj.Handle.hasMovePermission();
    
end
    