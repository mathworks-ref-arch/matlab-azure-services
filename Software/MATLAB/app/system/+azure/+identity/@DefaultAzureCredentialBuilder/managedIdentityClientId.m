function defaultAzureCredentialBuilder = managedIdentityClientId(obj, clientId)
% MANAGEDIDENTITYCLIENTID Specifies client ID of user or system assigned identity
% This credential can be used when in an environment with managed identities.
% If unset, the value in the AZURE_CLIENT_ID environment variable will be used.
% If neither is set, the default value is null and will only work with system
% assigned managed identities and not user assigned managed identities.
% An updated DefaultAzureCredentialBuilder is returned.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(clientId) || isStringScalar(clientId))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

defaultAzureCredentialBuilderj = obj.Handle.managedIdentityClientId(clientId);
defaultAzureCredentialBuilder = azure.identity.DefaultAzureCredentialBuilder(defaultAzureCredentialBuilderj);

end
