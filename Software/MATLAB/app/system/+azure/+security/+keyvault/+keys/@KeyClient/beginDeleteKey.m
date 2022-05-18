function syncPoller = beginDeleteKey(obj, keyName)
% BEGINDELETESECRET Deletes a key by name from Key Vault
% A azure.core.util.polling.syncPoller is returned.
% For details see: matlab-azure-common/Software/MATLAB/app/system/+azure/+core/+util/+polling/@SyncPoller
% keyName can be provided as a scalar character vector or string.
%
% Example:
%     key = keyClient.getKey('myKeyName');
%     syncPoller = keyClient.beginDeleteKey('myKeyName');
%     % Block until completion, allow a 10 second timeout
%     syncPoller.waitForCompletion(10);
%     % Other syncPoller methods are available, e.g. cancelOperation()

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(keyName) || isStringScalar(keyName))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected keyName to be of type character vector or scalar string');
end

pollerj = obj.Handle.beginDeleteKey(keyName);
syncPoller = azure.core.util.polling.SyncPoller(pollerj);

end