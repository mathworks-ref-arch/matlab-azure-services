function accountInfo = getAccountInfo(obj)
% GETACCOUNTINFO Returns the sku name and account kind for the account
% A StorageAccountInfo object is returned.

% Copyright 2020 The MathWorks, Inc.

accountInfoj = obj.Handle.getAccountInfo();
accountInfo = azure.storage.blob.models.StorageAccountInfo(accountInfoj);

end
