function result = exists(obj)
% EXISTS Tests if the container this client represents exists in Azure
% A logical is returned.

% Copyright 2020 The MathWorks, Inc.

result = obj.Handle.exists();

end