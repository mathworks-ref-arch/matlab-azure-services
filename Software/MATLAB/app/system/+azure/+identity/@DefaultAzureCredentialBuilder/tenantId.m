function defaultAzureCredentialBuilder = tenantId(obj, tenantId)
% TENANTID Sets tenant id of user to authenticate through DefaultAzureCredential
% An updated DefaultAzureCredentialBuilder is returned.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(tenantId) || isStringScalar(tenantId))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

defaultAzureCredentialBuilderj = obj.Handle.tenantId(tenantId);
defaultAzureCredentialBuilder = azure.identity.DefaultAzureCredentialBuilder(defaultAzureCredentialBuilderj);

end
