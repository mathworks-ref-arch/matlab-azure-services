function clientSecretCredentialBuilder = clientId(obj, clientId)
% CLIENTID Sets client id
% An updated ClientSecretCredentialBuilder is returned.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(clientId) || isStringScalar(clientId))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

clientSecretCredentialBuilderj = obj.Handle.clientId(clientId);
clientSecretCredentialBuilder = azure.identity.ClientSecretCredentialBuilder(clientSecretCredentialBuilderj);

end
