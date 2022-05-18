function clientSecretCredentialBuilder = authorityHost(obj, authorityHost)
% AUTHORITYHOST Specifies the Azure Active Directory endpoint to acquire tokens
% An updated ClientSecretCredentialBuilder is returned.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(authorityHost) || isStringScalar(authorityHost))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

clientSecretCredentialBuilderj = obj.Handle.authorityHost(authorityHost);
clientSecretCredentialBuilder = azure.identity.ClientSecretCredentialBuilder(clientSecretCredentialBuilderj);

end
