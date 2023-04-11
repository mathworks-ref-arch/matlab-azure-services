classdef ClientCertificateCredential < azure.core.credential.TokenCredential
% CLIENTCERTIFICATECREDENTIAL AAD credential acquires a token with a client certificate

% Copyright 2023 The MathWorks, Inc.

properties    
end

methods
    function obj = ClientCertificateCredential(clientCertificateCredentialj)
        % Created using a ClientCertificateCredential java object from the
        % ClientCertificateCredentialBuilder class only
        if isa(clientCertificateCredentialj, 'com.azure.identity.ClientCertificateCredential')
            obj.Handle = clientCertificateCredentialj;
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Expected argument of type com.azure.identity.ClientCertificateCredential');
        end
    end
end

end