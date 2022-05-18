classdef DefaultAzureCredential < azure.core.credential.TokenCredential
% DEFAULTAZURECREDENTIAL Creates credential from environment or the shared token
% It tries to create a valid credential in the following order:
%  EnvironmentCredential
%  ManagedIdentityCredential
%  SharedTokenCacheCredential
%  IntelliJCredential
%  VisualStudioCodeCredential
%  AzureCliCredential
%  Fails if none of the credentials above could be created.

% Copyright 2020 The MathWorks, Inc.

properties    
end

methods
    function obj = DefaultAzureCredential(defaultAzureCredentialj)
        % Created using a DefaultAzureCredential java object from the
        % DefaultAzureCredentialBuilder class only
        obj.Handle = defaultAzureCredentialj;
        if isa(defaultAzureCredentialj, 'com.azure.identity.DefaultAzureCredential')
            obj.Handle = defaultAzureCredentialj;
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Expected argument of type com.azure.identity.DefaultAzureCredential');
        end
    end
end

end