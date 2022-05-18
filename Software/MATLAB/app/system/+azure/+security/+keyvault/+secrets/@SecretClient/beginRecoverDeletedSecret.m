function syncPoller = beginRecoverDeletedSecret(obj, secretName)
% BEGINRECOVERDELETEDSECRET Recovers the deleted secret in the key vault to
% its latest version. Can only be performed on a soft-delete enabled vault.
% This operation requires the secrets/recover permission.
% A azure.core.util.polling.syncPoller is returned.
% secretName can be provided as a scalar character vector or string.
%
% Example:
%     syncPoller = secretClient.beginRecoverDeletedSecret('myDeletedSecretName');
%     % Block until completion, allow a 10 second timeout
%     syncPoller.waitForCompletion(10);
%     % Other syncPoller methods are available

% Copyright 2022 The MathWorks, Inc.

if ~(ischar(secretName) || isStringScalar(secretName))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected secretName to be of type character vector or scalar string');
end

pollerj = obj.Handle.beginRecoverDeletedSecret(secretName);
syncPoller = azure.core.util.polling.SyncPoller(pollerj);

end
