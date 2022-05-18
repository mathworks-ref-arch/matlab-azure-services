function sharedTokenCacheCredentialBuilder = tokenCachePersistenceOptions(obj, options)
% TOKENCACHEPERSISTENCEOPTIONS Sets tokenCachePersistenceOptions.

% Copyright 2022 The MathWorks, Inc.

if ~isa(options,'azure.identity.TokenCachePersistenceOptions')
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of com.azure.identity.TokenCachePersistenceOptions');
end

sharedTokenCacheCredentialBuilderj = obj.Handle.tokenCachePersistenceOptions(options.Handle);
sharedTokenCacheCredentialBuilder = azure.identity.SharedTokenCacheCredentialBuilder(sharedTokenCacheCredentialBuilderj);

end
