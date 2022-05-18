function clientSecretCredentialBuilder = clientSecret(obj, clientSecret)
% CLIENTID Sets the client secret for the authentication
% An updated ClientSecretCredentialBuilder is returned.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(clientSecret) || isStringScalar(clientSecret))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

clientSecretCredentialBuilderj = obj.Handle.clientSecret(clientSecret);
clientSecretCredentialBuilder = azure.identity.ClientSecretCredentialBuilder(clientSecretCredentialBuilderj);

end
