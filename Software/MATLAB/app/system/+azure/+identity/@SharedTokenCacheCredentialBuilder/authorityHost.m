function sharedTokenCacheCredentialBuilder = authorityHost(obj, authorityHost)
% AUTHORITYHOST Specifies the Azure Active Directory endpoint to acquire tokens
% An updated SharedTokenCacheCredentialBuilder is returned.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(authorityHost) || isStringScalar(authorityHost))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

sharedTokenCacheCredentialBuilderj = obj.Handle.authorityHost(authorityHost);
sharedTokenCacheCredentialBuilder = azure.identity.SharedTokenCacheCredentialBuilder(sharedTokenCacheCredentialBuilderj);

end
