function tokenCachePersistanceOptions = setName(obj, name)
% SETNAME Set the name.
% Returns an updated azure.core.identity.TokenCachePersistenceOptions.

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(name) || isStringScalar(name))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

tokenCachelPersistentOptionsj = obj.Handle.setName(name);
tokenCachePersistanceOptions = azure.identity.TokenCachePersistenceOptions(tokenCachelPersistentOptionsj);

end