function managedIdentityCredentialBuilder = clientId(obj, clientId)
% CLIENTID Sets client id
% An updated ManagedIdentityCredentialBuilder is returned.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(clientId) || isStringScalar(clientId))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

managedIdentityCredentialBuilderj = obj.Handle.clientId(clientId);
managedIdentityCredentialBuilder = azure.identity.ManagedIdentityCredentialBuilder(managedIdentityCredentialBuilderj);

end
