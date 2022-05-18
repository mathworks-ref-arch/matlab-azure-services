function kind = getAccountKind(obj, varargin)
% GETACCOUNTKIND Describes the type of the storage account
% Values: BLOB_STORAGE, BLOCK_BLOB_STORAGE, FILE_STORAGE, STORAGE, STORAGE_V2
% A character vector is returned rather than an enumeration

% Copyright 2020 The MathWorks, Inc.

kindj = obj.Handle.getAccountKind();
kind = char(kindj.toString());

end % function
