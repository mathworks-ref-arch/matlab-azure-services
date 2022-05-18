function interactiveBrowserCredentialBuilder = tokenCachePersistenceOptions(obj, options)
% tokenCachePersistenceOptions Sets tokenCachePersistenceOptions.

% Copyright 2022 The MathWorks, Inc.

if ~isa(options,'azure.identity.TokenCachePersistenceOptions')
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of azure.identity.TokenCachePersistenceOptions');
end

interactiveBrowserCredentialBuilderj = obj.Handle.tokenCachePersistenceOptions(options.Handle);
interactiveBrowserCredentialBuilder = azure.identity.InteractiveBrowserCredentialBuilder(interactiveBrowserCredentialBuilderj);

end
