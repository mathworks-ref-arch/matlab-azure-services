function result = getVersion(obj)
% GETVERSION Get the key version
% A character vector is returned.
    
% Copyright 2021 The MathWorks, Inc.
    
result = char(obj.Handle.getVersion());
    
end