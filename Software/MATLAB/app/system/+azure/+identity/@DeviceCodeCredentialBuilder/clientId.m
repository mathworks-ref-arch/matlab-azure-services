function deviceCodeCredentialBuilder = clientId(obj, clientId)
% CLIENTID Sets client id
% An updated DeviceCodeCredentialBuilder is returned.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(clientId) || isStringScalar(clientId))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

deviceCodeCredentialBuilderj = obj.Handle.clientId(clientId);
deviceCodeCredentialBuilder = azure.identity.DeviceCodeCredentialBuilder(deviceCodeCredentialBuilderj);

end
