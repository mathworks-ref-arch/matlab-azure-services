classdef StorageSharedKeyCredential < azure.object
% STORAGESHAREDKEYCREDENTIAL SharedKey credential policy 
% Used to put into a header to authorize requests.

% Copyright 2020 The MathWorks, Inc.

properties
end

methods
    function obj = StorageSharedKeyCredential(accountName, accountKey)
        if ~(ischar(accountName) || isStringScalar(accountName))
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid accountName type');
        end
        if ~(ischar(accountKey) || isStringScalar(accountKey))
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid accountKey type');
        end

        obj.Handle = com.azure.storage.common.StorageSharedKeyCredential(accountName, accountKey);
    end

end

end