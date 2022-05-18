function uri = getDirectoryUrl(obj)
% GETDIRECTORYURL Gets the URL of the directory represented by this client
% A matlab.net.URI is returned.

% Copyright 2022 The MathWorks, Inc.

uri = matlab.net.URI(char(obj.Handle.getDirectoryUrl()));

end