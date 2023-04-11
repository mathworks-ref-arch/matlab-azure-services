function clientCertificateCredentialBuilder = clientId(obj, clientId)
% CLIENTID Sets client id
% An updated ClientCertificateCredentialBuilder is returned.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(clientId) || isStringScalar(clientId))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

clientCertificateCredentialBuilderj = obj.Handle.clientId(clientId);
clientCertificateCredentialBuilder = azure.identity.ClientCertificateCredentialBuilder(clientCertificateCredentialBuilderj);

end
