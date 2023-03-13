function value = getSnapshot(obj)
% GETSNAPSHOT Returns the blob's snapshot property as a character vector

% Copyright 2023 The MathWorks, Inc.

value = char(obj.Handle.getSnapshot);

end