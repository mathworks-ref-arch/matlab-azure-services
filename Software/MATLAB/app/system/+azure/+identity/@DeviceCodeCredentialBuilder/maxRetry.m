function deviceCodeCredentialBuilder = maxRetry(obj, maxRetry)
% MAXRETRY Sets max number of retries when an authentication request fails
% An updated DeviceCodeCredentialBuilder is returned.

% Copyright 2020 The MathWorks, Inc.

if ~isinteger(maxRetry) || ~isscalar(maxRetry)
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of scalar integer');
end

deviceCodeCredentialBuilderj = obj.Handle.maxRetry(maxRetry);
deviceCodeCredentialBuilder = azure.identity.DeviceCodeCredentialBuilder(deviceCodeCredentialBuilderj);

end
