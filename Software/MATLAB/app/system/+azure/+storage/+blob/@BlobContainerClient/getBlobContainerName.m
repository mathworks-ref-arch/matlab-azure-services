function containterName = getBlobContainerName(obj)
% GETCONTAINERNAME Get the container name
% A character vector is returned.

% Copyright 2020 The MathWorks, Inc.

containterName = char(obj.Handle.getBlobContainerName());

end
    