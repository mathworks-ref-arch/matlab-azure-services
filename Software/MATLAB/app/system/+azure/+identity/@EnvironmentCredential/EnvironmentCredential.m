classdef EnvironmentCredential < azure.core.credential.TokenCredential
% ENVIRONMENTCREDENTIAL Provides token credentials based on environment variables
%  The environment variables expected are:
%    AZURE_CLIENT_ID
%    AZURE_CLIENT_SECRET
%    AZURE_TENANT_ID
% or:
%    AZURE_CLIENT_ID
%    AZURE_CLIENT_CERTIFICATE_PATH
%    AZURE_TENANT_ID
% or:
%    AZURE_CLIENT_ID
%    AZURE_USERNAME
%    AZURE_PASSWORD

% Copyright 2020 The MathWorks, Inc.

properties    
end

methods
    function obj = EnvironmentCredential(environmentCredentialj)
        % Created using a EnvironmentCredential java object from the
        % EnvironmentCredential class only
        if isa(environmentCredentialj, 'com.azure.identity.EnvironmentCredential')
            obj.Handle = environmentCredentialj;
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Expected argument of type com.azure.identity.EnvironmentCredential');
        end
    end
end

end