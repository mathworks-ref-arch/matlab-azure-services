classdef keyvaultFixture < matlab.unittest.fixtures.Fixture
    % Writes the configuration files based on environment variables, this
    % facilities unit testing in CI/CD setups
    
    % Copyright 2022 The MathWorks, Inc.    
    methods
        function setup(~)
            disp 'Writing Configuration Files'
            configFile = fullfile(AzureCommonRoot, 'config', 'test_ClientSecret.json');
            json = jsonencode(struct(...
                'AuthMethod','ClientSecret',...
                'TenantId',getenv('KEYVAULT_TENANT_ID'),...
                'ClientId',getenv('KEYVAULT_CLIENT_ID'),...
                'ClientSecret',getenv('KEYVAULT_CLIENT_SECRET'),...
                'VaultName',getenv('KEYVAULT_VAULT_NAME')...
            ));
            f = fopen(configFile,'w'); fwrite(f,json);fclose(f);

        end

        function teardown(~)
            disp 'Removing Configuration Files'
            delete(fullfile(AzureCommonRoot,'config','test_*.json'))
        end
    end
end