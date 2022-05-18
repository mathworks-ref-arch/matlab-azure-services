# Azure Key Vault

The MATLAB® Azure® Key Vault Interface enables the manipulation of Key Vault
Secrets and Keys from within MATLAB. Certificates are not currently supported.

## Configuration options

The higher-level client functions for this service use the same kind of configuration
options as discussed in [Configuration.md](Configuration.md). The service
specific options are discussed below.

The `createKeyVaultClient` function may use `VaultName` if not
specified in the call to `createKeyVaultClient`, for example:

```json
{
    "VaultName": "myvaultname"
}
```

The default name of the JSON file which `createKeyVaultClient` works with is `keyvaultsettings.json`.

## `createKeyVaultClient` function

`createKeyVaultClient` is a higher-level function for creating a `KeyClient` or
`SecretClient`

```matlab
% Create a KeyClient with default options
keyClient = createKeyVaultClient('Type','Key') 
% Create a SecretClient with default options
secretClient = createKeyVaultClient('Type','Secret') 
```

By default `createKeyVaultClient` reads credential information and the vault
name from a configuration file named `'keyvaultsettings.json'`. The function
automatically searches for this file on the MATLAB path. It is possible to
specify a different filename using `'ConfigurationFile'`. It is also possible to
provide `'Credentials'` and `'VaultName'` as inputs to the function directly in
which case no configuration file may be needed. See the Name, Value pairs below
for more details.

### Name, Value pairs
Additional Name, Value pairs can be supplied to configure non-default options:

**`'ConfigurationFile'`**, explicitly specify which configuration file to use.
This file is used for configuring Credentials (when not supplied as input)
and/or Account Name (when not supplied as input).

_Default Value:_ `'keyvaultsettings.json'`

**`'Credentials'`**, explicitly specify credentials to use. This for example
allows building multiple clients based on the same credentials without having to
go through (interactive) authentication again. If not specified,
`createKeyVaultClient` uses `configureCredentials` with 'ConfigurationFile' as
input to first configure credentials before building the client.

_Hint:_ configureCredentials can be used to build valid Credentials.

Example:

```matlab
credentials = configureCredentials('myCredentials.json');
keyClient = createKeyVaultClient('Credentials',credentials,'Type','Key')
secretClient = createKeyVaultClient('Credentials',credentials,'Type','Secret')
```

**`'VaultName'`**, explicitly specify the vault name for the client. If not
specified `createKeyVaultClient` uses `loadConfigurationSettings` to load
configuration options from `'ConfigurationFile'`. This file must then contain a
"VaultName" setting.

## Creating a secret client

A client is used to access secrets or keys in Key Vault. Certificates are not
currently supported.

A number of steps are required to build a client. A higher-level function
*createKeyVaultClient()* is provided to simplify this process. A key or secret
client can be created as follows:

If a configuration file path is not provided *createKeyVaultClient()* will
search the MATLAB path for a configuration file named ```keyvaultsettings.json```.

```matlab
secretClient = createKeyVaultClient('Type','Secret');
```

Here an optional non default configuration file path is provided.

```matlab
secretClient = createKeyVaultClient('Type','Secret','ConfigurationFile','C:\myFiles\matlab-azure-key-vault\Software\MATLAB\config\ClientSecret.json')
```

A client can be created manually as follows if customized configuration is
required, this should rarely be necessary and if so using a custom higher-level
wrapper function similar to *createKeyVaultClient()* is recommended:

```matlab
% Create a clientBuilder object, a SecretClient in this case
builder = azure.security.keyvault.secrets.SecretClientBuilder();

% Configure a credentials object based on a JSON config file
credentials = configureCredentials(which('azurekeyvault.json'));

% Alternatively a KeyClientBuilder is created as follows:
% builder = azure.security.keyvault.keys.KeyClientBuilder();

% Configure the builder using its methods
builder = builder.credential(credentials);
builder = builder.httpClient();
settings = loadConfigurationSettings(which('azurekeyvault.json'));
builder = builder.vaultUrl(sprintf('https://%s.vault.azure.net/',settings.VaultName));

% Create the client
secretClient = builder.buildClient();
```

A key client can be created similarly using the `Key` type:

```matlab
keyClient = createKeyVaultClient('Type','Key')
```

## Listing secrets in a vault

Secrets and keys have properties that can be obtained from Key Vault.

```matlab
% Create a client
secretClient = createKeyVaultClient('Type','Secret');

% Get an array of secret properties
propList = secretClient.listPropertiesOfSecrets();

% Get the name property for the first entry
name = propList(1).getName();
```

## Accessing a secret

A secret value is easily accessed using the client. Note it is best practice to
clear a secretValue from memory once it is no longer needed and consider
carefully how that value is used, e.g. written to a file etc. Also use
semi-colons to prevent the value unintentionally being logged to MATLAB's
console or other logs.

```matlab
% Create a client
secretClient = createKeyVaultClient('Type','Secret');
% Get the secret using its name
secret = secretClient.getSecret('mySecretName');
% Get the secret value
secretValue = secret.getValue();
```

## Creating a secret

Secrets are easily created using a name value pair. Note it is good practice to
_NOT_ include hardcoded secret values in code, contrary to this trivial example.

```matlab
secretClient = createKeyVaultClient('Type','Secret');
myNewSecret = secretClient.setSecret('mySecretName', 'mySecretValue');
```

## Deleting a secret

Deleting a secret is an asynchronous operation and a `SyncPoller` object is
returned. This can be used in a number of ways but in this simple example the
code blocks until completion or it times out. Deleting a secret is normally a
quick operation.

```matlab
secretClient = createKeyVaultClient('Type','Secret');

% Start the process of deleting a secret
syncPoller = secretClient.beginDeleteSecret('mySecretName');

% Block until the delete complete or the 10 second timeout elapses.
% The timeout value is optional, but can prevent unexpected hangs.
syncPoller.waitForCompletion(10);
```

## Additional operations on secrets in Key Vaults with soft-delete enabled

When working with key vaults with soft-delete enabled, deleted secrets can be
listed and recovered for a limited time, the default is 90 days but this can be
configured on a per key vault basis, or they can purged explicitly before this
time expires unless purge protection is enabled.

### Listing deleted secrets

```matlab
% Obtain the list of deleted secrets
deletedSecrets = secretClient.listDeletedSecrets();
% Get the name of the first deleted secret
secretName = deletedSecrets(1).getName();
% Check when the secret was deleted
deletedSecrets(1).getDeletedOn()
% Check when the secret is scheduled to be purged permanently
deletedSecrets(1).getScheduledPurgeDate()
```

> **Note:** The interface for Azure Key Vault follows the same design as
> Azure Key Vault Java SDK here, meaning that the returned `DeletedSecret`
> objects have the same methods as current secrets obtained with `getSecret`. So
> for example, they also have a `getValue` method. The Azure Key Vault Java SDK
> does not appear to actually return any values for deleted secrets however. To
> be able to obtain the value, first recover the secret and then query the value
> of the recovered secret.

### Recovering a deleted secret

Recovering a secret is an asynchronous operation and a `SyncPoller` object is
returned. This can be used in a number of ways but in this simple example the
code blocks until completion or it times out. Recovering a secret is normally a
quick operation.

```matlab
% Start the process of recovering a secret
syncPoller = secretClient.beginRecoverDeletedSecret(secretName);
% Block until the recovery complete or the 10 second timeout elapses.
% The timeout value is optional, but can prevent unexpected hangs.
syncPoller.waitForCompletion(10);
```

### Purging a deleted secret

Key vault names are globally unique. The names of secrets stored in a key vault
are also unique. So it is not possible to reuse the name of a secret that exists
in the soft-deleted state. Hence it can be preferred to purge a secret before it
is purged automatically on its scheduled purge date.

```matlab
% Purge a deleted secret right now
secretClient.purgeDeletedSecret(secretName);
```

## Creating a key client

A key client can be created as follows:

```matlab
% Here an optional non default configuration file path is provided.
keyClient = createKeyVaultClient('Type','Key','ConfigurationFile','C:\myFiles\matlab-azure-services\Software\MATLAB\config\ClientSecret.json')
```

By default *createKeyVaultClient()* will search the MATLAB path for ```keyvaultsettings.json```.

A client can be created manually as follows if customized configuration is
required, this should rarely be necessary and if so using a custom wrapper
script similar to *createKeyVaultClient()* is recommended:

```matlab

% Create a clientBuilder object, a KeyClient in this case
builder = azure.security.keyvault.keys.KeyClientBuilder();

% Configure a credentials object based on a JSON config file
credentials = configureCredentials(which('azurekeyvault.json'));

% Configure the builder using its methods
builder = builder.credential(credentials);
builder = builder.httpClient();
settings = loadConfigurationSettings(which('azurekeyvault.json'));
builder = builder.vaultUrl(sprintf('https://%s.vault.azure.net/',settings.VaultName));

% Create the client
keyClient = builder.buildClient();
```

## Listing keys in a vault

Keys have properties that can be obtained from Key Vault.

```matlab
% Create a client
keyClient = createKeyVaultClient('Type','Key');

% Get an array of secret properties
properties = keyClient.listPropertiesOfKeys();

% Get the name property for the first entry
name = propList(1).getName();
```

## Accessing a Key

A key can be returned in a number of forms, see
azure.security.keyvault.keys.models.JsonWebKey _to_ methods. For
interoperability with other security libraries these methods return a Java key
object of varying types.

```matlab
% Create a client
keyClient = createKeyVaultClient('Type','Key');
% Get the key using its name
jsonWebKey = keyClient.getKey('myKeyName');
% Convert the key to java.security.KeyPair RSA form
keyRsa = jsonWebKey.toRsa(false);
```

## Creating a key

Keys are easily created using a name and key type.

```matlab
keyClient = createKeyVaultClient('Type','Key');
rsaKey = azure.security.keyvault.keys.models.KeyType.RSA;
key = keyClient.createKey('myTestRSAKey', rsaKey)
```

## Deleting a key

Deleting a key is an asynchronous operation and a _SyncPoller_ object is
returned. This can be used in a number of ways but in this simple example the
code blocks until completion or it times out. Deleting a key is normally a quick
operation.

```matlab
keyClient = createKeyVaultClient('Type','Key');

% Start the process of deleting a key
syncPoller = keyClient.beginDeleteKey('myTestRSAKey');

% Block until the delete complete or the 10 second timeout elapses.
% The timeout value is optional, but can prevent unexpected hangs
syncPoller.waitForCompletion(10);
```

## Additional operations on keys in Key Vaults with soft-delete enabled

When working with key vaults with soft-delete enabled, deleted keys can be
listed and recovered for a limited time, the default is 90 days but this can be
configured on a per key vault basis, or purged explicitly before this time
expires unless purge protection is enabled.

### Listing deleted keys

```matlab
% Obtain the list of deleted keys
deletedKeys = keyClient.listDeletedKeys();
% Get the recovery ID of the first deleted key
recoveryId = deletedKeys(1).getRecoveryId();
% Check when the key was deleted
deletedKeys(1).getDeletedOn()
% Check when the key is scheduled to be purged permanently
deletedKeys(1).getScheduledPurgeDate()
```

> **Note:** The interface for Azure Key Vault follows the same design as
> Azure Key Vault Java SDK here, meaning that the returned `DeletedKey` objects
> have the same methods as current keys obtained with `getKey`. So for example
> they also have a `getKey` and `getName` method. The Azure Key Vault Java SDK
> does not appear to actually return all values for deleted keys though. For a
> list of deleted keys obtained with `listDeletedKeys` it does not even appear
> to be able to return the name for delete keys with `getName`. In that sense
> the best option to obtain the name of a deleted key appears to be to use
> `getRecoveryId` and then parse the return URI:
>
> ```matlab
> % Use matlab.net.URI to help parse the returned ID 
> recoveryURI = matlab.net.URI(deletedKeys(1).getRecoveryId());
> % The name of the key should be the last part of the URI Path
> keyName = recoveryURI.Path{end};
> ```

### Recovering a deleted key

Recovering a key is an asynchronous operation and a `SyncPoller` object is
returned. This can be used in a number of ways but in this simple example the
code blocks until completion or times out. Recovering a key is normally a quick
operation.

```matlab
% Start the process of recovering a secret
syncPoller = keyClient.beginRecoverDeletedKey(keyName);
% Block until the recovery complete or the 10 second timeout elapses.
% The timeout value is optional, but can prevent unexpected hangs.
syncPoller.waitForCompletion(10);
```

### Purging a deleted key

Key vault names are globally unique. The names of keys stored in a key vault are
also unique. So it is not possible to reuse the name of a key that exists in the
soft-deleted state. Hence it can be preferred to purge a key before it is purged
automatically on its scheduled purge date.

```matlab
% Purge a deleted key right now
keyClient.purgeDeletedKey(keyName);
```

[//]: #  (Copyright 2021-2022 The MathWorks, Inc.)
