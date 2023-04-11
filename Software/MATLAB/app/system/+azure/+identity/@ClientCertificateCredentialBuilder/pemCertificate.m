function clientCertificateCredentialBuilder = pemCertificate(obj, certificatePath)
% PEMCERTIFICATE Sets the path of the PEM certificate for authenticating to AAD
% An updated ClientCertificateCredentialBuilder is returned.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(certificatePath) || isStringScalar(certificatePath))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

if exist(certificatePath, 'file') ~= 2
    logObj = Logger.getLogger();
    write(logObj,'error',['File not found: ', strrep(char(certificatePath),'\','\\')]);
end 

clientCertificateCredentialBuilderj = obj.Handle.pemCertificate(certificatePath);
clientCertificateCredentialBuilder = azure.identity.ClientCertificateCredentialBuilder(clientCertificateCredentialBuilderj);

end