classdef SharedTokenCacheCredential < azure.core.credential.TokenCredential
    % DEVICECODECREDENTIAL A credential provider that provides token
    % credentials from the MSAL shared token cache.
    
    % Copyright 2022 The MathWorks, Inc.
    
    methods
        function obj = SharedTokenCacheCredential(varargin)

            if length(varargin) == 1
                sharedTokenCacheCredentialj = varargin{1};
                if isa(sharedTokenCacheCredentialj, 'com.azure.identity.SharedTokenCacheCredential')
                    obj.Handle = sharedTokenCacheCredentialj;
                else
                    logObj = Logger.getLogger();
                    write(logObj,'error','Expected argument of type com.azure.identity.SharedTokenCacheCredential');
                end
            elseif isempty(varargin)
            else
                logObj = Logger.getLogger();             
                write(logObj,'error','Unexpected number of arguments');
            end
        end
    end
   
    methods(Static)
        result = restFlow(clientId, tenantId, authorityHost)
        sas = restGetSas(accessToken, startTime, expiryTime, AccountName)
    end

end