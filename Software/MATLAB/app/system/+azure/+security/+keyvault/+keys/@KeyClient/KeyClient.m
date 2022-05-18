classdef KeyClient < azure.object
% KEYCLIENT A KeyClient object for transacting keys with the Key Vault
%
% Example:
%     % Create a client using the createKeyVaultClient() function
%     % Here an optional non default configuration file path is provided that holds
%     % Client Secret style credentials
%     keyClient = createKeyVaultClient('Type','Key','ConfigurationFile','C:\myFiles\matlab-azure-key-vault\Software\MATLAB\config\ClientSecret.json')
%
%  Or
%
%     % If a configuration file path is not provided *createKeyVaultClient()* will search
%     % MATLAB path for a configuration file named ```keyvaultsettings.json```:
%     keyClient = createKeyVaultClient('Type','Key');
%
%  Or
%
%     % Alternatively a client can also be created manually to 
%     % Configure the logger level and message prefix if not already configured
%     initialize('displayLevel', 'debug', 'loggerPrefix', 'Azure:KeyVault');
%
%     % Configure a credentials object based on a JSON config file
%     credentials = configureCredentials(which('keyvaultsettings.json'));
%
%     % Create a client builder object, a KeyClient in this case
%     builder = azure.security.keyvault.keys.KeyClientBuilder();
%
%     % Configure the builder using its methods
%     builder = builder.credential(credentials);
%     builder = builder.httpClient();
%     settings = loadConfigurationSettings(which('keyvaultsettings.json'));
%     builder = builder.vaultUrl(sprintf('https://%s.vault.azure.net/',settings.VaultName));
%
%     % Create the client
%     keyClient = builder.buildClient();


% Copyright 2021-2022 The MathWorks, Inc.

    properties
    end
 
    methods
        function obj = KeyClient(varargin)
            if nargin == 1 && isa(varargin{1}, 'com.azure.security.keyvault.keys.KeyClient')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','KeyClient must be created using KeyClientBuilder');
            end
        end
    end
end