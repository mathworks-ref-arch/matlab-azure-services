classdef storageFixture < matlab.unittest.fixtures.Fixture
    % Writes the configuration files based on environment variables, this
    % facilities unit testing in CI/CD setups
    
    % Copyright 2022 The MathWorks, Inc.
    
    methods
        function setup(~)
            disp 'Writing Configuration Files'
            % Create Configuration Files Based on Environment 
            configFile = fullfile(AzureCommonRoot, 'config', 'test_ConnectionString.json');
            json = jsonencode(struct(...
                'AuthMethod','ConnectionString',...
                'ConnectionString',getenv('STORAGE_CONNECTION_STRING')...
            ));
            f = fopen(configFile,'w'); fwrite(f,json);fclose(f);

            copyfile(configFile,fullfile(AzureCommonRoot, 'config','storagesettings.json'));
            
            configFile = fullfile(AzureCommonRoot, 'config', 'test_StorageSharedKey.json');
            json = jsonencode(struct(...
                'AuthMethod','StorageSharedKey',...
                'AccountKey',getenv('STORAGE_ACCOUNT_KEY'),...
                'AccountName',getenv('STORAGE_ACCOUNT_NAME')...
            ));
            f = fopen(configFile,'w'); fwrite(f,json);fclose(f);
            
            configFile = fullfile(AzureCommonRoot, 'config', 'test_ClientSecret.json');
            json = jsonencode(struct(...
                'AuthMethod','ClientSecret',...
                'TenantId',getenv('AZURE_TENANT_ID'),...
                'ClientId',getenv('AZURE_CLIENT_ID'),...
                'ClientSecret',getenv('AZURE_CLIENT_SECRET'),...
                'AccountName',getenv('STORAGE_ACCOUNT_NAME')...
            ));
            f = fopen(configFile,'w'); fwrite(f,json);fclose(f);
        end

        function teardown(~)
            disp 'Removing Configuration Files'
            delete(fullfile(AzureCommonRoot,'config','test_*.json'))
            delete(fullfile(AzureCommonRoot,'config','storagesettings.json'))
        end
    end
end