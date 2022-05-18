function credentialBuilder = maxRetry(obj, maxRetry)
% MAXRETRY Sets max number of retries when an authentication request fails

% Copyright 2020 The MathWorks, Inc.

if ~isinteger(maxRetry) || ~isscalar(maxRetry)
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of scalar integer');
end

credentialBuilderj = obj.Handle.maxRetry(maxRetry);
credentialBuilder = azure.identity.ManagedIdentityCredentialBuilder(credentialBuilderj);

end
