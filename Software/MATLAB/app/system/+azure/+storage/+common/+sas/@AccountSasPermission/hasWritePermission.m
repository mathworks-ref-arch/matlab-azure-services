function tf = hasWritePermission(obj)
% HASWRITEPERMISSION Returns the write permission status
% The result is returned as a logical.
    
% Copyright 2020 The MathWorks, Inc.
    
tf = obj.Handle.hasWritePermission();
    
end
    