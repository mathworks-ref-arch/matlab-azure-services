classdef SecretClient < azure.object
% SECRETCLIENT A SecretClient object for transacting secrets with the Key Vault
%
% Example
%     % Create a Secret client using the higher-level createKeyVaultClient() function
%     % Here an optional non default configuration file path is provided that holds
%     % Client Secret style credentials:
%     secretClient = createKeyVaultClient('Type','Secret','ConfigurationFile','C:\myFiles\matlab-azure-key-vault\Software\MATLAB\config\ClientSecret.json')
%
%  Or
%
%     % If a configuration file path is not provided *createKeyVaultClient()* will search
%     % MATLAB path for a configuration file named ```keyvaultsettings.json```:
%     secretClient = createKeyVaultClient('Type','Secret');
%
%  Or
%
%     % Alternatively a client can also be created manually using the builder for
%     % this class:
%     % Create a client builder object, a SecretClient in this case
%     builder = azure.security.keyvault.secrets.SecretClientBuilder();
%
%     % Configure a credentials object based on a JSON config file
%     credentials = configureCredentials(which('keyvaultsettings.json'));
%
%     % Configure the builder using its methods
%     builder = builder.credential(credentials);
%     builder = builder.httpClient();
%     settings = loadConfigurationSettings(which('keyvaultsettings.json'));
%     builder = builder.vaultUrl(sprintf('https://%s.vault.azure.net/',settings.VaultName));
%
%     % Create the client
%     secretClient = builder.buildClient();

% Copyright 2020-2022 The MathWorks, Inc.

    properties
    end
 
    methods
        function obj = SecretClient(varargin)
            if nargin == 1 && isa(varargin{1}, 'com.azure.security.keyvault.secrets.SecretClient')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','SecretClient must be created using SecretClientBuilder');
            end
        end
    end
end