classdef (SharedTestFixtures={keyvaultFixture}) testSecretClient < matlab.unittest.TestCase
    % TESTSECRETCLIENT Azure KeyVault tests
    % The test suite exercises the basic operations on the Client.

    % Copyright 2020-2021 The MathWorks, Inc.

    properties
        logObj;
    end

    methods(TestClassSetup)
        function testClassSetup(testCase)
            initialize('displayLevel', 'verbose', 'loggerPrefix', 'Azure:KeyVault');
            testCase.logObj = Logger.getLogger();
        end
    end

    methods(TestClassTeardown)
        function testClassTeardown(testCase) %#ok<MANU>
        end
    end

    methods (TestMethodSetup)
        function testMethodSetup(testCase) %#ok<MANU>
        end
    end

    methods(TestMethodTeardown)
        function testMethodTeardown(testCase) %#ok<MANU>
        end
    end


    methods (Test)
        function testSecretClientConstructor(testCase)
            disp('Running testSecretClientConstructor');
            % Create a secret client and test handle and class uses clientsecret auth
            builder = azure.security.keyvault.secrets.SecretClientBuilder();
            testCase.verifyClass(builder, 'azure.security.keyvault.secrets.SecretClientBuilder');
            testCase.verifyClass(builder.Handle, 'com.azure.security.keyvault.secrets.SecretClientBuilder');
            
            configFilePath = fullfile(AzureCommonRoot, 'config', 'test_ClientSecret.json');
            credentials = configureCredentials(configFilePath);
            builder = builder.credential(credentials);
            builder = builder.httpClient();
            settings = loadConfigurationSettings(configFilePath);
            builder = builder.vaultUrl(sprintf('https://%s.vault.azure.net/',settings.VaultName));
            clientSecretSecretClient = builder.buildClient();
            
            testCase.verifyClass(clientSecretSecretClient, 'azure.security.keyvault.secrets.SecretClient');
            testCase.verifyClass(clientSecretSecretClient.Handle, 'com.azure.security.keyvault.secrets.SecretClient');
        end


        function testGetSecret(testCase)
            disp('Running testGetSecret');
            % Return and check a known secret value
            configFilePath = fullfile(AzureCommonRoot, 'config', 'test_ClientSecret.json');
            clientSecretSecretClient = createKeyVaultClient('Type','secret','ConfigurationFile', configFilePath);
            secret = clientSecretSecretClient.getSecret('anakin');
            testCase.verifyClass(secret, 'azure.security.keyvault.secrets.models.KeyVaultSecret');
            testCase.verifyTrue(strcmp(secret.getValue, 'darth'));

            % Check failure mode for nonexistent secret
            testCase.verifyError(@()clientSecretSecretClient.getSecret('nonexistantsecret'), 'MATLAB:Java:GenericException');
        end
        
        
        function testSetSecret(testCase)
            disp('Running testSetSecret');
            % Set a secret and check its value, then delete it and check it is removed
            uuidStr = char(java.util.UUID.randomUUID().toString());
            configFilePath = fullfile(AzureCommonRoot, 'config', 'test_ClientSecret.json');
            clientSecretSecretClient = createKeyVaultClient('Type','secret','ConfigurationFile', configFilePath);
            
            secretName = ['unitTestSecret-' uuidStr];

            secretA = clientSecretSecretClient.setSecret(secretName, uuidStr);
            secretB = clientSecretSecretClient.getSecret(secretName);
            
            testCase.verifyTrue(strcmp(secretA.getValue(), secretB.getValue()));
            testCase.verifyTrue(strcmp(secretA.getName(), secretName));
            testCase.verifyTrue(strcmp(secretB.getName(), secretName));
            
            testCase.verifyTrue(ischar(secretB.getId));
            testCase.verifyNotEmpty(secretB.getId);
            
            syncPoller = clientSecretSecretClient.beginDeleteSecret(secretName);
            % Allow a 10 second timeout
            syncPoller.waitForCompletion(10);
            
            % Check the secret is gone
            testCase.verifyError(@()clientSecretSecretClient.getSecret(secretName), 'MATLAB:Java:GenericException');

            % But does still exist as deleted secret
            testCase.verifyClass(clientSecretSecretClient.getDeletedSecret(secretName),?azure.security.keyvault.secrets.models.DeletedSecret);

            % Recover the secret
            syncPoller = clientSecretSecretClient.beginRecoverDeletedSecret(secretName);
            % Allow a 10 second timeout
            syncPoller.waitForCompletion(10);

            % Verify the secret exists again
            secret = clientSecretSecretClient.getSecret(secretName);
            testCase.verifyClass(secret,?azure.security.keyvault.secrets.models.KeyVaultSecret);
            % With correct value
            testCase.verifyEqual(secret.getValue,uuidStr);

            % Delete once more
            syncPoller = clientSecretSecretClient.beginDeleteSecret(secretName);
            % Allow a 10 second timeout
            syncPoller.waitForCompletion(10);            

            % Again, Check the secret is gone
            testCase.verifyError(@()clientSecretSecretClient.getSecret(secretName), 'MATLAB:Java:GenericException');

            % Again, but does still exist as deleted secret
            testCase.verifyClass(clientSecretSecretClient.getDeletedSecret(secretName),?azure.security.keyvault.secrets.models.DeletedSecret);

            % Now also purge the secret
            clientSecretSecretClient.purgeDeletedSecret(secretName);
            % Check the deleted secret is gone entirely
            testCase.verifyError(@()clientSecretSecretClient.getDeletedSecret(secretName), 'MATLAB:Java:GenericException');

            % And indeed cannot be recovered now
            testCase.verifyError(@()clientSecretSecretClient.beginRecoverDeletedSecret(secretName), 'MATLAB:Java:GenericException');
        end
        
        function testListDeletedSecrets(testCase)
            disp('Running testListDeletedSecrets');
            
            % Create and delete a secret such that there will be at least
            % one item in the list of deleted secrets
            uuidStr = char(java.util.UUID.randomUUID().toString());
            configFilePath = fullfile(AzureCommonRoot, 'config', 'test_ClientSecret.json');
            clientSecretSecretClient = createKeyVaultClient('Type','secret','ConfigurationFile', configFilePath);
            
            secretName = ['unitTestSecret-' uuidStr];
            clientSecretSecretClient.setSecret(secretName,uuidStr);

            % Verify it exists
            secret = clientSecretSecretClient.getSecret(secretName);
            testCase.verifyClass(secret,?azure.security.keyvault.secrets.models.KeyVaultSecret);

            % Delete
            syncPoller = clientSecretSecretClient.beginDeleteSecret(secretName);
            % Allow a 10 second timeout
            syncPoller.waitForCompletion(10);

            % Get the list 
            deletedSecrets = clientSecretSecretClient.listDeletedSecrets;
            % Verify class 
            testCase.verifyClass(deletedSecrets,?azure.security.keyvault.secrets.models.DeletedSecret)
            % Verify there is at least one item
            testCase.verifyGreaterThan(length(deletedSecrets),0)

            % Delete all items in the list (also cleaning up after any
            % previously failed tests)
            for i = 1:length(deletedSecrets)
                name = deletedSecrets(i).getName;
                clientSecretSecretClient.purgeDeletedSecret(name);
                % Verify indeed gone
                testCase.verifyError(@()clientSecretSecretClient.getSecret(name), 'MATLAB:Java:GenericException');
            end

            % Verify list empty now
            deletedSecrets = clientSecretSecretClient.listDeletedSecrets;
            % Verify class 
            testCase.verifyClass(deletedSecrets,?azure.security.keyvault.secrets.models.DeletedSecret)
            % Verify there is at least one item
            testCase.verifyEmpty(deletedSecrets)


        end

        
        function testListSecrets(testCase)
            disp('Running testSetSecret');
            % Get a list of current secret properties and do a basic test of metadata
            configFilePath = fullfile(AzureCommonRoot, 'config', 'test_ClientSecret.json');
            clientSecretSecretClient = createKeyVaultClient('Type','secret','ConfigurationFile',configFilePath);
            
            propList = clientSecretSecretClient.listPropertiesOfSecrets();
            testCase.verifyClass(propList, 'azure.security.keyvault.secrets.models.SecretProperties');
            
            testCase.verifyGreaterThan(length(propList), 0);
            testCase.verifyTrue(strcmp(propList(1).getId, [clientSecretSecretClient.getVaultUrl(),'secrets/', propList(1).getName()]));
        end
    end
end