function tenantId = getTenantId(obj)
% GETTENANTID Get the tenant id to be used for the authentication request
% Returns a character vector.

% Copyright 2021 The MathWorks, Inc.

tenantId = char(obj.Handle.getTenantId());

end