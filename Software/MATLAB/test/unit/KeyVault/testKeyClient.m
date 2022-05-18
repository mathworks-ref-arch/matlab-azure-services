classdef (SharedTestFixtures={keyvaultFixture}) testKeyClient < matlab.unittest.TestCase
    % TESTKEYCLIENT KeyVault tests
    % The test suite exercises the basic operations on the Client.

    % Copyright 2021 The MathWorks, Inc.

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
        function testKeyClientConstructor(testCase)
            disp('Running testKeyClientConstructor');
            % Create a key client and test handle and class uses clientsecret auth
            builder = azure.security.keyvault.keys.KeyClientBuilder();
            testCase.verifyClass(builder, 'azure.security.keyvault.keys.KeyClientBuilder');
            testCase.verifyClass(builder.Handle, 'com.azure.security.keyvault.keys.KeyClientBuilder');

            configFilePath = fullfile(AzureCommonRoot, 'config', 'test_ClientSecret.json');
            credentials = configureCredentials(configFilePath);
            builder = builder.credential(credentials);
            builder = builder.httpClient();
            settings = loadConfigurationSettings(configFilePath);
            builder = builder.vaultUrl(sprintf('https://%s.vault.azure.net/',settings.VaultName));
            clientSecretKeyClient = builder.buildClient();

            testCase.verifyClass(clientSecretKeyClient, 'azure.security.keyvault.keys.KeyClient');
            testCase.verifyClass(clientSecretKeyClient.Handle, 'com.azure.security.keyvault.keys.KeyClient');
        end


        function testGetKey(testCase)
            disp('Running testGetKey');
            % Return and check a known key
            configFilePath = fullfile(AzureCommonRoot, 'config', 'test_ClientSecret.json');
            clientSecretKeyClient = createKeyVaultClient('Type','key', 'ConfigurationFile', configFilePath);
            key = clientSecretKeyClient.getKey('kvtestkey');
            testCase.verifyClass(key, 'azure.security.keyvault.keys.models.KeyVaultKey');
            keyType = key.getKeyType();
            testCase.verifyClass(keyType, 'azure.security.keyvault.keys.models.KeyType');
            testCase.verifyTrue(strcmp(keyType.toString, 'RSA'));

            % Return as a jsonWebKey and test
            jsonWebKey = key.getKey();
            testCase.verifyClass(jsonWebKey, 'azure.security.keyvault.keys.models.JsonWebKey');
            testCase.verifyTrue(jsonWebKey.isValid);
            keyRsa = jsonWebKey.toRsa(false);
            testCase.verifyClass(keyRsa, 'java.security.KeyPair');

            % Check failure mode for nonexistent secret
            testCase.verifyError(@()clientSecretKeyClient.getKey('nonexistantkey'), 'MATLAB:Java:GenericException');            
        end
        
        
        function testCreateKey(testCase)
            disp('Running testCreateKey');
            % Set a secret and check its value, then delete it and check it is removed
            uuidStr = char(java.util.UUID.randomUUID().toString());
            configFilePath = fullfile(AzureCommonRoot, 'config', 'test_ClientSecret.json');
            clientSecretKeyClient = createKeyVaultClient('Type','key','ConfigurationFile', configFilePath);
            
            keyName = ['unitTestKey-' uuidStr];

            rsaKey = azure.security.keyvault.keys.models.KeyType.RSA;
            keyA = clientSecretKeyClient.createKey(keyName, rsaKey);
            keyB = clientSecretKeyClient.getKey(keyName);

            keyType = keyB.getKeyType();
            testCase.verifyTrue(strcmp(rsaKey.toString(), keyType.toString()));
            testCase.verifyTrue(strcmp(keyA.getName(), keyName));
            testCase.verifyTrue(strcmp(keyB.getName(), keyName));
            
            testCase.verifyTrue(ischar(keyB.getId));
            testCase.verifyNotEmpty(keyB.getId);

            syncPoller = clientSecretKeyClient.beginDeleteKey(keyName);
            % Allow a 10 second timeout
            syncPoller.waitForCompletion(10);
            
            % Verify indeed deleted
            testCase.verifyError(@()clientSecretKeyClient.getKey(keyName), 'MATLAB:Java:GenericException');
            
            % But still exists as deleted key
            dkey = clientSecretKeyClient.getDeletedKey(keyName);
            testCase.verifyNotEmpty(dkey);
            testCase.verifyClass(dkey,?azure.security.keyvault.keys.models.DeletedKey);
            
            % Recover it
            syncPoller = clientSecretKeyClient.beginRecoverDeletedKey(keyName);
            % Allow a 10 second timeout
            syncPoller.waitForCompletion(10);

            % Verify it indeed again exists as actual key
            key = clientSecretKeyClient.getKey(keyName);
            testCase.verifyNotEmpty(key);
            testCase.verifyEqual(key.getName,keyName);

            % Delete again

            syncPoller = clientSecretKeyClient.beginDeleteKey(keyName);
            % Allow a 10 second timeout
            syncPoller.waitForCompletion(10);
            
            % Verify indeed deleted
            testCase.verifyError(@()clientSecretKeyClient.getKey(keyName), 'MATLAB:Java:GenericException');

            % Now also purge
            clientSecretKeyClient.purgeDeletedKey(keyName);

            % Verify that deleted key is gone now as well.
            testCase.verifyError(@()clientSecretKeyClient.getDeletedKey(keyName), 'MATLAB:Java:GenericException');
        end


        function testListDeletedKeys(testCase)
            disp('Running testListDeletedKeys');

            % Create a key and then delete it to ensure there is at least
            % one key in the list
            uuidStr = char(java.util.UUID.randomUUID().toString());
            configFilePath = fullfile(AzureCommonRoot, 'config', 'test_ClientSecret.json');
            clientSecretKeyClient = createKeyVaultClient('Type','key','ConfigurationFile', configFilePath);
            
            keyName = ['unitTestKey-' uuidStr];

            rsaKey = azure.security.keyvault.keys.models.KeyType.RSA;
            keyA = clientSecretKeyClient.createKey(keyName, rsaKey);

            syncPoller = clientSecretKeyClient.beginDeleteKey(keyName);
            % Allow a 10 second timeout
            syncPoller.waitForCompletion(10);

            % Get the list
            deletedKeys = clientSecretKeyClient.listDeletedKeys;
            % Verify type 
            testCase.verifyClass(deletedKeys,?azure.security.keyvault.keys.models.DeletedKey);
            % And that there is at least one deleted key
            testCase.verifyGreaterThan(length(deletedKeys),0)

            % Now purge all keys in the list (also cleaning up after
            % previously failed tests)
            for i=1:length(deletedKeys)
                % The Azure SDK does not appear to return names for the
                % keys obtained through listDeletedKeys, so parse the name
                % from the recovery URI instead
                uri = matlab.net.URI(deletedKeys(i).getRecoveryId);
                name = uri.Path{end};
                clientSecretKeyClient.purgeDeletedKey(name);
                % Verify that key is indeed purged
                testCase.verifyError(@()clientSecretKeyClient.getDeletedKey(name), 'MATLAB:Java:GenericException');
            end
        end
        
        function testListKeys(testCase)
            disp('Running testListKeys');
            % Get a list of current key properties and do a basic test of metadata
            configFilePath = fullfile(AzureCommonRoot, 'config', 'test_ClientSecret.json');
            clientSecretKeyClient = createKeyVaultClient('Type','key','ConfigurationFile', configFilePath);
            
            propList = clientSecretKeyClient.listPropertiesOfKeys();
            testCase.verifyClass(propList, 'azure.security.keyvault.keys.models.KeyProperties');
            
            testCase.verifyGreaterThan(length(propList), 0);
            testCase.verifyTrue(strcmp(propList(1).getId, [clientSecretKeyClient.getVaultUrl(),'keys/', propList(1).getName()]));
        end
    end
end