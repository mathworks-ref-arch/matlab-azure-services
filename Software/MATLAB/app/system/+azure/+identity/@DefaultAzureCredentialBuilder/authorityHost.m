function defaultAzureCredentialBuilder = authorityHost(obj, authorityHost)
% AUTHORITYHOST Specifies the Azure Active Directory endpoint to acquire tokens
% An updated DefaultAzureCredentialBuilder is returned.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(authorityHost) || isStringScalar(authorityHost))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

defaultAzureCredentialBuilderj = obj.Handle.authorityHost(authorityHost);
defaultAzureCredentialBuilder = azure.identity.DefaultAzureCredentialBuilder(defaultAzureCredentialBuilderj);

end
