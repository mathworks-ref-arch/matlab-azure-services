function clientCertificateCredential = build(obj)
% BUILD Creates new ClientCertificateCredential with the configured options set

% Copyright 2023 The MathWorks, Inc.

clientCertificateCredentialj = obj.Handle.build();
clientCertificateCredential = azure.identity.ClientCertificateCredential(clientCertificateCredentialj);

end