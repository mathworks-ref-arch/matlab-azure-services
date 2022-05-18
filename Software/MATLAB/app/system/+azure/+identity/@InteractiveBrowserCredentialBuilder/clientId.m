function interactiveBrowserCredentialBuilder = clientId(obj, clientId)
% CLIENTID Sets client id
% An updated InteractiveBrowserCredentialBuilder is returned.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(clientId) || isStringScalar(clientId))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

interactiveBrowserCredentialBuilderj = obj.Handle.clientId(clientId);
interactiveBrowserCredentialBuilder = azure.identity.InteractiveBrowserCredentialBuilder(interactiveBrowserCredentialBuilderj);

end
