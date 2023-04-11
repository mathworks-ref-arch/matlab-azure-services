function clientCertificateCredentialBuilder = tenantId(obj, tenantId)
% TENANTID Sets tenant id to authenticate through ClientCertificateCredential
% An updated ClientCertificateCredentialBuilder is returned.

% Copyright 2023 The MathWorks, Inc.

if ~(ischar(tenantId) || isStringScalar(tenantId))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

clientCertificateCredentialBuilderj = obj.Handle.tenantId(tenantId);
clientCertificateCredentialBuilder = azure.identity.ClientCertificateCredentialBuilder(clientCertificateCredentialBuilderj);

end
