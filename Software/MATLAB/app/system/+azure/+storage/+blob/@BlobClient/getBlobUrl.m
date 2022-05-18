function url = getBlobUrl(obj)
% GETBLOBURL Gets the URL of the blob represented by this client
% The URL is returned as a character vector.

% Copyright 2020 The MathWorks, Inc.

url = char(obj.Handle.getBlobUrl());

end