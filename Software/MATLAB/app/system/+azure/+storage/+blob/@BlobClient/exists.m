function result = exists(obj)
% EXISTS Gets if the blob this client represents exists in Azure
% A logical is returned.

% Copyright 2020 The MathWorks, Inc.

% Returns a Boolean convert to boolean and then logical
resultj = obj.Handle.exists();
result = resultj.booleanValue;

end