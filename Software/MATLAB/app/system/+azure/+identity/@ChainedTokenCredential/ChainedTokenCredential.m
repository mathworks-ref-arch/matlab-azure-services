classdef ChainedTokenCredential < azure.core.credential.TokenCredential
% CHAINEDTOKENCREDENTIAL Provides a credential from a list of providers

% Copyright 2020 The MathWorks, Inc.

methods
    function obj = ChainedTokenCredential(chainedTokenCredentialj)
        if isa(chainedTokenCredentialj, 'com.azure.identity.ChainedTokenCredential')
            obj.Handle = chainedTokenCredentialj;
        else
            write(logObj,'error','Expected argument of type com.azure.identity.ChainedTokenCredential');
        end
    end
end

end