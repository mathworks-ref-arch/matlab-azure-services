function accountName = getAccountName(obj)
% GETACCOUNTNAME Gets the account name associated with the request
% The accountName is returned as a character vector.

% Copyright 2020 The MathWorks, Inc.

accountName = char(obj.Handle.getAccountName);

end