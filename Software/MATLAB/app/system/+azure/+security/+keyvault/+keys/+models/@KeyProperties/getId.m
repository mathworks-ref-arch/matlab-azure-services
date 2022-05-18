function result = getId(obj)
% GETID Get the secret identifier
% A character vector is returned.

% Copyright 2021 The MathWorks, Inc.

result = char(obj.Handle.getId());

end