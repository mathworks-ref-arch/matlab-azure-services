function accountName = getAccountName(obj)
% GETACCOUNTNAME Get associated account name
% A character vector is returned.

% Copyright 2020 The MathWorks, Inc.
accountName = char(obj.Handle.getAccountName());

end
