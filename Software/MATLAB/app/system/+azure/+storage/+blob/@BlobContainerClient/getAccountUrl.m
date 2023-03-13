function accountUrl = getAccountUrl(obj)
% GETACCOUNTURL Get associated account URL
% A character vector is returned.

% Copyright 2023 The MathWorks, Inc.

accountUrl = char(obj.Handle.getAccountUrl());

end
