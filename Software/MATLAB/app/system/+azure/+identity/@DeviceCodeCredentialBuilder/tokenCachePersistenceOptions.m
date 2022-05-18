function deviceCodeCredentialBuilder = tokenCachePersistenceOptions(obj, options)
% TOKENCACHEPERSISTENCEOPTIONS Sets tokenCachePersistenceOptions.

% Copyright 2022 The MathWorks, Inc.

if ~isa(options,'azure.identity.TokenCachePersistenceOptions')
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of azure.identity.TokenCachePersistenceOptions');
end

deviceCodeCredentialBuilderj = obj.Handle.tokenCachePersistenceOptions(options.Handle);
deviceCodeCredentialBuilder = azure.identity.DeviceCodeCredentialBuilder(deviceCodeCredentialBuilderj);

end
