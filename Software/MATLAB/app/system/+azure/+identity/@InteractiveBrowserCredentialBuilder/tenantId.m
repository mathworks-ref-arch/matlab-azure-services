function interactiveBrowserCredentialBuilder = tenantId(obj, tenantId)
% TENANTID Sets tenant id of user to authenticate through InteractiveBrowserCredential
% An updated InteractiveBrowserCredentialBuilder is returned.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(tenantId) || isStringScalar(tenantId))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

interactiveBrowserCredentialBuilderj = obj.Handle.tenantId(tenantId);
interactiveBrowserCredentialBuilder = azure.identity.InteractiveBrowserCredentialBuilder(interactiveBrowserCredentialBuilderj);

end
