classdef ClientSecretCredential < azure.core.credential.TokenCredential
% CLIENTSECRETCREDENTIAL AAD credential acquires a token with a client secret

% Copyright 2020 The MathWorks, Inc.

properties    
end

methods
    function obj = ClientSecretCredential(clientSecretCredentialj)
        % Created using a ClientSecretCredential java object from the
        % ClientSecretCredentialBuilder class only
        if isa(clientSecretCredentialj, 'com.azure.identity.ClientSecretCredential')
            obj.Handle = clientSecretCredentialj;
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Expected argument of type com.azure.identity.ClientSecretCredential');
        end
    end
end

end