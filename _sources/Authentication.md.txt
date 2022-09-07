# Authentication

Azure® supports a variety of authentication methods. These can be invoked
specifically or as a series of failover attempts in a so-called provider-chain.

When working with high level functions like `createStorageClient` or
`createKeyVaultClient`, these will automatically perform the authentication and
then use these credentials to automatically create the service specific clients.
The authentication details are read from JSON Configuration files as also
discussed in [Configuration.md](Configuration.md). Each service has its own
filename for its default JSON configuration file. Most functions also accept an
alternative configuration filename as input. The configuration files may contain
service specific non-authentication related options as well.

See the service specific documentation to learn more about the default filename
for each service and how to provide an alternative filename if desired. 

See the sections below to learn more about which settings need to be added in
the JSON configuration files for the various authentication methods. 

Alternatively, if not using the high level functions for creating service
specific clients and using the Client *Builders* instead, the Credential objects
can still first be build using the `configureCredentials` function (which is in
fact also used internally by the higher level functions). This function must be
called with a specific configuration filename as input, e.g.:

```matlab
credentials = configureCredentials('myCredentialConfiguration.json')
```

Again, see the sections below on what options need to be configured in the file
for the different authentication methods.

Lastly, it is also possible to build Credential objects on the lowest level with
the help of Credential *Builders*; see the [APIReference](APIReference.md) for
more details on these classes. This approach does not require any configuration
files.

The following authentication approaches are supported:

1.  [Azure CLI](#azure-cli)
2.  [Managed Identity](#managed-identity)
3.  [Client Secret](#client-secret)
4.  [Environment Variable](#environment-variable)
5.  [Shared Token Cache](#shared-token-cache)
6.  [Interactive Browser](#interactive-browser)
7.  [Device Code](#device-code)
8.  [Default Azure](#default-azure)
9.  [Storage Shared Key](#storage-shared-key)
10. [Connection String](#connection-string)
11. [Chained Token](#chained-token)

## Azure CLI

This approach uses credentials used to previously authenticate to the Azure CLI
tool when the ```az login``` command is used. The Azure CLI login process
supports a number of authentication processes many of which are common to this
package.

### Sample ```myServiceSpecificSettings.json```

```json
{
    "AuthMethod": "AzureCli"
}
```

For more information on the CLI see: [Azure CLI
site](https://docs.microsoft.com/en-us/cli/azure/)

## Managed Identity

Managed identities provide an identity for the Azure resource in Azure Active
Directory (Azure AD) and use it to obtain Azure AD tokens. Thus identities do
not have to be directly managed by the developer or end user. This can be
particularly useful in a deployed scenario as credentials should not be embedded
in a compiled MATLAB application or CTF file, rather the application can in
effect derive its credentials by virtue of the machine hosting it in Azure.

### Managed Identity ```myServiceSpecificSettings.json```

```json
{
    "AuthMethod": "ManagedIdentity"
}
```

## Client Secret

A Client Secret credential is an Azure AD credential that acquires a token with
a client secret. The secret can be provided in the form as a string specified as
```ClientSecret``` or can be a certificate referred to by ```pemCertificate```.

### Client Secret ```myServiceSpecificSettings.json```

```json
{
    "AuthMethod": "ClientSecret",
    "TenantId" : "99d<REDACTED>1e6",
    "ClientId" : "811<REDACTED>8ee",
    "ClientSecret": "i6Q<REDACTED>p72", //Either 
    "pemCertificate": "c:/path/to/clientCert.pem", //Or
    "AuthorityHost": "https://myauthority.com/" //Optional
}
```

## Environment Variable

With Environment Variable based credentials the variables must be set in the
process used to start MATLAB® such that the variables apply to the JVM which is
configured when MATLAB starts and is not affected by MATLAB ```setenv``` calls.
The following combinations of credentials are accepted:

1. AZURE_CLIENT_ID, AZURE_CLIENT_SECRET & AZURE_TENANT_ID
2. AZURE_CLIENT_ID, AZURE_CLIENT_CERTIFICATE_PATH & AZURE_TENANT_ID
3. AZURE_CLIENT_ID, AZURE_USERNAME & AZURE_PASSWORD

Environment Variable credentials can often be used in CI/CD based processes.
Additional note the support for a certificate file path.

### Environment Variable ```myServiceSpecificSettings.json```
```json
{
    "AuthMethod": "Environment",
    "AuthorityHost": "https://myauthority.com/" //Optional
}
```

## Shared Token Cache

With `SharedTokenCacheCredential`, credentials are read from a cache saved on
disk (Windows®) or GNOME keyring (Linux). It _is_ possible to work with Shared
Token Cache directly, in which case the tokens need to already exist in the
cache. _However_, in more practical situations it is recommended to use Shared
Token Cache in combination with an other authentication method like Interactive
Browser or Device Code.

Interactive Browser and Device Code can be configured in such a way that they
will store the tokens which they obtain interactively in the cache.
`configureCredentials` will then also configure these workflows to first try to
read the token from the cache, such that if the token already exists in the
cache, these methods do not have to go through their interactive flow anymore
and they can complete without user interaction.

Specifying a cache `Name` is optional, `TokenCachePersistenceOptions` can be
provided as empty object. In this case the default name "msal" is used on
Windows and "MSALCache" on Linux.

### Shared Token Cache ```myServiceSpecificSettings.json```

```json
{
    "AuthMethod": "SharedTokenCache",
    "TenantId" : "99d<REDACTED>1e6",
    "ClientId" : "811<REDACTED>8ee",
    "TokenCachePersistenceOptions" : {
        "Name": "myMATLABCache" //Optional
    }  
}
```

## Interactive Browser

When Interactive Browser credentials are used an Azure Active Directory
credential acquires a token for an Azure AD application by prompting the login
in the default browser. When authenticated, the oauth2 flow will notify the
credential of the authentication code through the reply URL. The application to
authenticate to must have delegated user login permissions and
have```http://localhost:port``` listed as a valid Redirect URI for the Azure
App.

### TokenCachePersistenceOptions

Interactive Browser can optionally be configured with
`TokenCachePersistenceOptions`. When these are configured,
`configureCredentials` will actually build and return a `ChainedTokenCredential`
object instead of an `InteractiveBrowserCredential`. The first option in this
chain will be a `SharedTokenCacheCredential` and the second option an
`InteractiveBrowserCredential` configured to persist the tokens it obtains in
the same cache.

When using this the very first time, the token will not exist in the cache and
the Interactive Browser workflow will be executed interactively. This will then
store the obtained token in the cache. If the same authentication method is then
used again later, the token _can_ be read from the cache and the authentication
flow will complete without needing any action from the end-user.

### Interactive Browser ```myServiceSpecificSettings.json```

```json
{
    "AuthMethod": "InteractiveBrowser",
    "TenantId" : "99d<REDACTED>1e6",
    "ClientId" : "811<REDACTED>8ee",    
    "RedirectUrl": "http://localhost:8765",
    "AuthorityHost": "https://myauthority.com/", //Optional
    "TokenCachePersistenceOptions" : { //Optional
        "Name": "myMATLABCache"        //Optional
    }  
}
```

## Device Code

`DeviceCodeCredential` enables authentication to Azure AD using a device code
that the user can enter into
[https://microsoft.com/devicelogin](https://microsoft.com/devicelogin).

Note that in general the actual authentication provided through the credential
objects is only executed when the client (KeyClient, BlobClient, etc.) requires
it (typically on the first operation you perform using the client). In general
the Azure Java SDK follows this same workflow when working with Device Code
Credentials. However, in MATLAB specifically, MATLAB will _not_ be able to
display the device code while other client code is already running, so MATLAB
requires the Device Code authentication to be explicitly performed _before_
passing the credentials to a client. This also means MATLAB cannot rely on the
client to automatically request the correct scope by itself and therefore it is
required to specify the correct scopes in the configuration file. Scopes are
entered as an array of strings.

### Scopes

Azure DataLake Storage Gen2 typically requires the
`https://storage.azure.com/.default` scope.

Key Vault typically requires the `https://vault.azure.net/.default` scope.

> **_NOTE:_** it is **not** possible to request access to multiple different
> resources (services) in one authentication call. This is a limitation from the
> Azure end and not specific to this package.
>
> I.e. it is **not** possible to request both
> `https://storage.azure.com/.default` _and_ `https://vault.azure.net/.default`
> Scopes simultaneously to obtain a single Credential object which is then
> usable with both Storage clients as well as Key Vault clients. Separate
> Credential objects will have to be obtained for the different Scopes and then
> passed to the different Clients.

### Building *and* authenticating

`configureCredentials` will automatically build the `DeviceCodeCredential`
object _and_ authenticate it for the scopes configured in the settings file. The
`DeviceCodeCredential` object which is returned will be "pre-authenticated" in
that sense.

By default the instructions for the end-user on how to complete the device code
authentication flow are printed to the Command Window. An optional
`'DeviceCodeCallback'` Name-Value input pair can be passed to
`configureCredentials` to specify a custom callback function for displaying the
device code instructions:

```matlab
credentials = configureCredentials('settings_DeviceCode.json',,...
    'DeviceCodeCallback',@myExampleCallbackFunction);
```

This callback will then be called during the authentication flow with an
`azure.identity.DeviceCodeInfo` object as input. Use the information provided in
this object to display instructions to the end user on how to complete the
authentication flow. Or for example use this to automatically copy the code to
clipboard and open a browser:

```matlab
function myExampleCallbackFunction(deviceCodeInfo)
    % Simply still print to instructions to the Command Window
    disp(deviceCodeInfo.getMessage)
    % But also copy the code to the clipboard
    clipboard("copy",deviceCodeInfo.getUserCode);
    % And open a browser
    web(deviceCodeInfo.getVerificationUrl);
```

### TokenCachePersistenceOptions

Device Code can optionally be configured with `TokenCachePersistenceOptions`.
When these are configured, `configureCredentials` will actually build and return
a `SharedTokenCacheCredential` object instead of a `DeviceCodeCredential`. The
internal workflow is as follows then:

1. A `SharedTokenCacheCredential` is built and MATLAB uses it to try to obtain a
   valid token for the specified scope from the cache. If this succeeds the
   `SharedTokenCacheCredential` is returned immediately without any end-user
   interaction.

2. If no token could be obtained from the cache, a `DeviceCodeCredential` is
   built and configured to store obtained tokens in the cache _and_ it is then
   authenticated for the requested scope. This will require the end-user to
   perform the authentication interactively. Once this interactive flow has
   completed, the tokens which were obtained during this, will have been stored
   in the cache, so it sufficient now for `configureCredentials` to return the
   `SharedTokenCacheCredential` and there is no need to return the
   `DeviceCodeCredential`.

### Device Code ```myServiceSpecificSettings.json```
```json
{
    "AuthMethod": "DeviceCode",
    "TenantId" : "99d<REDACTED>1e6",
    "ClientId" : "811<REDACTED>8ee",    
    "Scopes": [
        "https://storage.azure.com/.default"
    ],
    "AuthorityHost": "https://myauthority.com/", //Optional
    "TokenCachePersistenceOptions" : { //Optional
        "Name": "myMATLABCache"        //Optional
    }
}
```

## Default Azure

A ```DefaultAzureProviderCredential``` attempts to create a credential using
environment variables or the shared token cache. It tries to create a valid
credential in the following order:

1. EnvironmentCredential
2. ManagedIdentityCredential
3. SharedTokenCacheCredential
4. IntelliJCredential
5. VisualStudioCodeCredential
6. AzureCliCredential
7. Fails if none of the credentials above could be created.

The chained token provider allows for customization of this process (see below).
Note in the following JSON config file the ManagedIdentityClientId, TenantId and
AuthorityHost are optional fields depending on which means of authentication is
expected to be used.

### Default Azure ```myServiceSpecificSettings.json```
```json
{
    "AuthMethod": "DefaultAzure",
    "TenantId" : "99d<REDACTED>1e6", //Optional
    "ManagedIdentityClientId" : "811<REDACTED>8ee", //Optional
    "AuthorityHost": "https://myauthority.com/" //Optional
}
```

## Storage Shared Key

This approach is only supported/relevant when working with Azure Storage
workflows and can for example _not_ be used when working with Azure Key Vault
workflows.

This approach creates a ```StorageSharedKeyCredential``` containing an account's
name and its primary or secondary accountKey. The ```accountName``` is the
account name associated with the request and the ```accountKey``` is the account
access key used to authenticate the request. 

To obtain the primary or secondary key:

1. Sign in to the Azure portal.
2. Locate the storage account.
3. In the account's settings section, select "Access keys", showing the access
   keys and the connection string for each key.
4. Select the "Key" string value for key1 or key2 and copy the value.

### Storage Shared Key ```myServiceSpecificSettings.json```

```json
{
    "AuthMethod": "StorageSharedKey",
    "AccountKey" : "lrd<REDACTED>g==",
    "AccountName" : "a<REDACTED>t"
}
```

Connection String is a form of ```StorageSharedKeyCredential``` where the
credential is simply the connection string.

## Connection String

This approach is only supported/relevant when working with Azure Storage
workflows and can for example not be used when working with Azure Key Vault
workflows.

A connection string contains all the relevant connection properties, like the
account name and authentication information in one big string. The
authentication information can be in the form of a Storage Shared Key or a SAS
signature.

To obtain a connection string based on Storage Shared Key:

1. Sign in to the Azure portal.
2. Locate the storage account.
3. In the account's settings section, select "Access keys", showing the access
   keys and the connection string for each key.
4. Select the "Connection string" value for key1 or key2 and copy the value.

To obtain a connection string based on a SAS signature:

1. Sign in to the Azure portal
2. Locate the storage account
3. In the account's settings section, select "Shared access signature".
4. Configure the permissions and access properties as required/desired and click
   "Generate SAS and connection string".
5. Select the "Connection string" value and copy the value.

### Connection String ```myServiceSpecificSettings.json```

```json
{
    "AuthMethod": "ConnectionString",
    "ConnectionString": "DefaultEndpointsProtocol=https;<REDACTED CONNECTION STRING>g==;EndpointSuffix=core.windows.net"
}
```

Alternatively the connection string can be passed as an environment value as
follows: On Windows using cmd:

```bat
setx AZURE_STORAGE_CONNECTION_STRING "<myConnectionString>"
```

Or on Linux/macOS using bash:

```bash
export AZURE_STORAGE_CONNECTION_STRING="<myConnectionString>"
```

## Chained Token

Using a Chained Token provider allows a list of token based credential providers
to be built such that the authentication process will fall through the providers
until successful or the list is exhausted. Connection String and Storage Shared
Key approaches are not token based. Credentials are built in the usual way but
rather than being used directly they are *added* to the
```chainedTokenCredentialBuilder``` in descending order of preference. This
builder is then built and the result provides the client's credentials.

```matlab
chainedTokenCredentialBuilder = chainedTokenCredentialBuilder.addLast(clientSecretCredentials);
chainedTokenCredentials = chainedTokenCredentialBuilder.build();
serviceClientBuilder = serviceClientBuilder.credential(chainedTokenCredentials);
```

In this case multiple settings files are used to build the individual
credentials by passing a specific path e.g.:

```matlab
clientSecretCredentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'settings_ClientSecret.json'));
```

[//]: #  (Copyright 2020-2022 The MathWorks, Inc.)
