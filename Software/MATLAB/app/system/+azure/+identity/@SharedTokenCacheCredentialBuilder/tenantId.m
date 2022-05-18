function sharedTokenCacheCredentialBuilder = tenantId(obj, tenantId)
% TENANTID Sets tenant id to authenticate through SharedTokenCacheCredential
% An updated SharedTokenCacheCredentialBuilder is returned.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(tenantId) || isStringScalar(tenantId))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

sharedTokenCacheCredentialBuilderj = obj.Handle.tenantId(tenantId);
sharedTokenCacheCredentialBuilder = azure.identity.SharedTokenCacheCredentialBuilder(sharedTokenCacheCredentialBuilderj);

end
