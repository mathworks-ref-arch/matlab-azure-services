classdef ManagedIdentityCredential < azure.core.credential.TokenCredential
% MANAGEDIDENTITYCREDENTIAL Managed Service Identity token based credentials

% Copyright 2020-2021 The MathWorks, Inc.

methods
    function obj = ManagedIdentityCredential(managedIdentityCredentialj)
        if isa(managedIdentityCredentialj, 'com.azure.identity.ManagedIdentityCredential')
            obj.Handle = managedIdentityCredentialj;
        else
            write(logObj,'error','Expected argument of type com.azure.identity.ManagedIdentityCredential');
        end
    end
end

end