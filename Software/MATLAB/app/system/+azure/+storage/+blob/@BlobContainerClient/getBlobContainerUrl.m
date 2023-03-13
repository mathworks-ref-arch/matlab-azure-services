function containerUrl = getBlobContainerUrl(obj)
% GETBLOBCONTAINERURL Get associated container URL
% A character vector is returned.

% Copyright 2023 The MathWorks, Inc.

containerUrl = char(obj.Handle.getBlobContainerUrl());

end
