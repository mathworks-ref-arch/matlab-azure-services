function result = getVersion(obj)
% GETVERSION Get the keyId identifier
% A character vector is returned.

% Copyright 2021 The MathWorks, Inc.

result = char(obj.Handle.getVersion());

end