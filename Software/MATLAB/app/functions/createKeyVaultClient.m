function client = createKeyVaultClient(varargin)
    % CREATEKEYVAULTCLIENT Convenience function for creating KeyClient and
    % SecretClient
    %
    %   client = createKeyVaultClient('Type','Key') creates a KeyClient with
    %   default options.
    %
    %   client = createKeyVaultClient('Type','Secret') creates SecretClient with
    %   default options.
    %
    % By default createKeyVaultClient reads Credential information and the
    % Vault Name from a configuration file named 'keyvaultsettings.json'. The
    % function automatically searches for this file on the MATLABPATH. It is
    % possible to specify a different filename using 'ConfigurationFile'. It is
    % also possible to provide 'Credentials' and 'VaultName' as inputs to the
    % function directly in case which no configuration file may be needed. See
    % the Name, Value pairs below for more details.
    %
    % Additional Name, Value pairs can be supplied to configure non-default
    % options:
    %
    %   'ConfigurationFile', explicitly specify which configuration file to
    %       use. This file is used for configuring Credentials (when not
    %       supplied as input) and/or Account Name (when not supplied as input).
    %
    %       Default Value: 'keyvaultsettings.json'
    %
    %   'Credentials', explicitly specify credentials to use. This for example
    %       allows building multiple clients based on the same credentials
    %       without having to go through (interactive) authentication again. If
    %       not specified, createKeyVaultClient uses configureCredentials with
    %       'ConfigurationFile' as input to first configure credentials before
    %       building the client.
    %
    %       Hint: configureCredentials can be used to build valid Credentials.
    %
    %       Example:
    %           credentials = configureCredentials('myCredentials.json');
    %           client1 = createKeyVaultClient('Credentials',credentials,'Type','Key')
    %           client2 = createKeyVaultClient('Credentials',credentials,'Type','Secret')
    %
    %   'VaultName', explicitly specify the Vault name for the client. If not
    %       specified createKeyVaultClient uses loadConfigurationSettings to
    %       load configuration options from 'ConfigurationFile'. This file must
    %       then contain a "VaultName" setting.
    %
    %   See also CONFIGURECREDENTIALS, LOADCONFIGURATIONSETTINGS

    % Copyright 2022 The MathWorks, Inc.

    initialize('displayLevel', 'debug', 'loggerPrefix', 'Azure:KeyVault');

    logObj = Logger.getLogger();

    p = inputParser;
    p.FunctionName = 'createKeyVaultClient';

    p.addParameter('Credentials',[],...
        @(x) isa(x, 'azure.core.credential.TokenCredential'));

    p.addParameter('Type',[],@(x) ischar(x) || isStringScalar(x));
    p.addParameter('ConfigurationFile','keyvaultsettings.json',@(x) ischar(x) || isStringScalar(x))
    p.addParameter('VaultName',[],@(x) ischar(x) || isStringScalar(x));

    p.parse(varargin{:});

    if isempty(p.Results.Credentials)
        credentials = configureCredentials(p.Results.ConfigurationFile);
    else
        credentials = p.Results.Credentials;
    end

    if isempty(p.Results.Type)
        write(logObj,'error','Type must be specified.');
    else
        type = p.Results.Type;
    end

    switch lower(type)
        case 'key'
            builder = azure.security.keyvault.keys.KeyClientBuilder();
        case 'secret'
            builder = azure.security.keyvault.secrets.SecretClientBuilder();
    end

    builder = builder.credential(credentials);

    if isempty(p.Results.VaultName)
        config = loadConfigurationSettings(p.Results.ConfigurationFile);
        vaultUrl = sprintf('https://%s.vault.azure.net/',config.VaultName);
    else
        vaultUrl = sprintf('https://%s.vault.azure.net/',p.Results.VaultName);
    end
    builder = builder.vaultUrl(vaultUrl);

    builder = builder.httpClient();

    client = builder.buildClient();
end
