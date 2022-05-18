function filePath = getFilePath(obj)
% GETFILEPATH Gets the path of this file, not including the name of the resource itself
% A character vector is returned.

% Copyright 2022 The MathWorks, Inc.

filePath = char(obj.Handle.getFilePath());

end