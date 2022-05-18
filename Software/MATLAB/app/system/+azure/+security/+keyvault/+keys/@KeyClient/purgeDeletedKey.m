function purgeDeletedKey(obj, name)
% PURGEDELETEDKEY Permanently deletes the specified key without the
% possibility of recovery. The Purge Deleted Key operation is applicable
% for soft-delete enabled vaults. This operation requires the keys/purge
% permission.
% The name argument is provided as a character vector or scalar string.
% The function throws an error if no deleted key can be found. Returns
% nothing upon success.
%
% Example:
%     keyClient.purgeDeletedKey('myKeyName');

% Copyright 2022 The MathWorks, Inc.

if ~(ischar(name) || isStringScalar(name))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected name to be of type character vector or scalar string');
end

obj.Handle.purgeDeletedKey(name);

end
    