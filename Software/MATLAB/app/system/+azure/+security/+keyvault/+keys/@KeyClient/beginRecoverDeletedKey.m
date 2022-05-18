function syncPoller = beginRecoverDeletedKey(obj, keyName)
% BEGINRECOVERDELETEDKEY Recovers the deleted key in the key vault to its
% latest version and can only be performed on a soft-delete enabled vault.
% A azure.core.util.polling.syncPoller is returned.
% For details see: matlab-azure-common/Software/MATLAB/app/system/+azure/+core/+util/+polling/@SyncPoller
% keyName can be provided as a scalar character vector or string.
%
% Example:
%     syncPoller = keyClient.beginRecoverDeletedKey('myKeyName');
%     % Block until completion, allow a 10 second timeout
%     syncPoller.waitForCompletion(10);
%     % Other syncPoller methods are available, e.g. cancelOperation()

% Copyright 2022 The MathWorks, Inc.

if ~(ischar(keyName) || isStringScalar(keyName))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected keyName to be of type character vector or scalar string');
end

pollerj = obj.Handle.beginRecoverDeletedKey(keyName);
syncPoller = azure.core.util.polling.SyncPoller(pollerj);

end