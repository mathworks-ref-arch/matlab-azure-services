function clientSecretCredentialBuilder = tenantId(obj, tenantId)
% TENANTID Sets tenant id to authenticate through ClientSecretCredential
% An updated ClientSecretCredentialBuilder is returned.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(tenantId) || isStringScalar(tenantId))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

clientSecretCredentialBuilderj = obj.Handle.tenantId(tenantId);
clientSecretCredentialBuilder = azure.identity.ClientSecretCredentialBuilder(clientSecretCredentialBuilderj);

end
