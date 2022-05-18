function syncPoller = beginDeleteSecret(obj, secretName)
% BEGINDELETESECRET Deletes a secret by name from Key Vault
% A azure.core.util.polling.syncPoller is returned.
% keyName can be provided as a scalar character vector or string.
%
% Example:
%     secret = secretClient.getSecret('mySecretName');
%     syncPoller = secretClient.beginDeleteSecret('mySecretName');
%     % Block until completion, allow a 10 second timeout
%     syncPoller.waitForCompletion(10);
%     % Other syncPoller methods are available

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(secretName) || isStringScalar(secretName))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected secretName to be of type character vector or scalar string');
end

pollerj = obj.Handle.beginDeleteSecret(secretName);
syncPoller = azure.core.util.polling.SyncPoller(pollerj);

end