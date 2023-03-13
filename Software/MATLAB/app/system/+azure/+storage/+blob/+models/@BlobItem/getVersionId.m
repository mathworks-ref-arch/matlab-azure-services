function value = getVersionId(obj)
% GETVERSIONID Returns the blob's versionId property as a character vector

% Copyright 2023 The MathWorks, Inc.

value = char(obj.Handle.getVersionId);

end