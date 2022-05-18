function tf = hasUpdatePermission(obj)
% HASUPDATEPERMISSION Returns the update permission status
% It allows the update of queue message and tables.
% This allows the retrieval and deletion of queue messages.
% The result is returned as a logical.
    
% Copyright 2020 The MathWorks, Inc.
    
tf = obj.Handle.hasUpdatePermission();
    
end
    