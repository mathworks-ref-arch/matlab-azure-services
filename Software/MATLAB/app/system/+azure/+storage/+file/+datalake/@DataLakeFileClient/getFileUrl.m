function uri = getFileUrl(obj)
% GETFILEURL Gets the URL of the file represented by this client
% A matlab.net.URI is returned.

% Copyright 2022 The MathWorks, Inc.

uri = matlab.net.URI(obj.Handle.getFileUrl());

end