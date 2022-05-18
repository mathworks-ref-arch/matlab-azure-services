function tokenRequestContext = setTenantId(obj, tenantId)
% SETTENANTID Set the tenant id to be used for the authentication request
% The tenantId should be provided as a character vector or scalar string.
% Returns an updated azure.core.credential.TokenRequestContext.

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(tenantId) || isStringScalar(tenantId))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

tokenRequestContextj = obj.Handle.setTenantId(tenantId);
tokenRequestContext = azure.core.credential.TokenRequestContext(tokenRequestContextj);

end