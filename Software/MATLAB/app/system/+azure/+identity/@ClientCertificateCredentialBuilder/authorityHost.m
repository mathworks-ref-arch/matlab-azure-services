function clientCertificateCredentialBuilder = authorityHost(obj, authorityHost)
% AUTHORITYHOST Specifies the Azure Active Directory endpoint to acquire tokens
% An updated ClientCertificateCredentialBuilder is returned.

% Copyright 2023 The MathWorks, Inc.

if ~(ischar(authorityHost) || isStringScalar(authorityHost))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

clientCertificateCredentialBuilderj = obj.Handle.authorityHost(authorityHost);
clientCertificateCredentialBuilder = azure.identity.ClientCertificateCredentialBuilder(clientCertificateCredentialBuilderj);

end
