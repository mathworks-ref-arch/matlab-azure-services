function sharedTokenCacheBuilder = clientId(obj, clientId)
% CLIENTID Sets client id
% An updated SharedTokenCacheCredentialBuilder is returned.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(clientId) || isStringScalar(clientId))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

sharedTokenCacheCredentialBuilderj = obj.Handle.clientId(clientId);
sharedTokenCacheBuilder = azure.identity.SharedTokenCacheCredentialBuilder(sharedTokenCacheCredentialBuilderj);

end
