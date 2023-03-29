function managedIdentityCredentialBuilder = resourceId(obj, resourceId)
% RESOURCEID Sets client id
% An updated ManagedIdentityCredentialBuilder is returned.

% Copyright 2023 The MathWorks, Inc.

if ~(ischar(resourceId) || isStringScalar(resourceId))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

managedIdentityCredentialBuilderj = obj.Handle.resourceId(resourceId);
managedIdentityCredentialBuilder = azure.identity.ManagedIdentityCredentialBuilder(managedIdentityCredentialBuilderj);

end
