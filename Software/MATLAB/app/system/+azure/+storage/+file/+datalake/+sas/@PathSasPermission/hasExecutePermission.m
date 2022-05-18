function tf = hasExecutePermission(obj)
% HASEXECUTEPERMISSION Returns the execute permission status
% The result is returned as a logical.
    
% Copyright 2022 The MathWorks, Inc.
    
tf = obj.Handle.hasExecutePermission();
    
end
    