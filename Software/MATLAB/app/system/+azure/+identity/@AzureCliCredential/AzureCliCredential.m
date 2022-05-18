classdef AzureCliCredential < azure.core.credential.TokenCredential
% AZURECLICREDENTIAL Provides token credentials based on Azure CLI command
% If the CLI is installed and authenticated there is no need to further
% authenticate within MATLAB.
% A object is created based on a corresponding Java com.azure.identity.AzureCliCredential
% object.

% Copyright 2020 The MathWorks, Inc.

properties    
end

methods
    function obj = AzureCliCredential(azureCliCredentialj)
        % Created using a AzureCliCredential java object from the
        % AzureCliCredentialBuilder class only
        if isa(azureCliCredentialj, 'com.azure.identity.AzureCliCredential')
            obj.Handle = azureCliCredentialj;
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Expected argument of type com.azure.identity.AzureCliCredential');
        end
    end
end

end