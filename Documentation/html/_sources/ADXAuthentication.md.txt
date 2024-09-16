# Authentication

To create a settings file interactively use: `mathworks.internal.adx.buildSettingsFile`.

Template JSON configuration files for various authentication approaches can be
found in `matlab-azure-adx/Software/MATLAB/config`

In general for initial testing Client Secret based authentication is the simplest
to configure an work with. To use other approaches it is recommended to contact
MathWorks®: <mwlab@mathworks.com>.

Certain authentication methods require the additional use of the Azure Java SDK
authentication support as documented in [Authentication.md](Authentication.md).

| Authentication Method | JSON file field value | Java SDK support required |
|:----------------------|:----------------------|:-------------------------:|
| Client Secret         | clientSecret          | No                        |
| Interactive Browser   | interactiveBrowser    | Yes                       |
| Device Code           | deviceCode            | Yes                       |
| Managed Identity      | managedIdentity       | Yes                       |

If you wish to use an Azure authentication method that is not listed please contact MathWorks at: <mwlab@mathworks.com>.

## Settings file fields

The default settings file is: `matlab-azure-adx/Software/MATLAB/config/adx.Client.Settings.json`
Alternative names and paths can be used if required.
Depending on the authentication method used different fields are required. The
template files for the documented methods show the fields for the various methods.

For example Interactive Browser uses:

```json
{
    "preferredAuthMethod" : "interactiveBrowser",
    "subscriptionId" : "<REDACTED>",
    "tenantId" : "<REDACTED>",
    "clientId" : "<REDACTED>",
    "database" : "<defaultDatabaseName>",
    "resourceGroup": "<resourceGroupName>",
    "cluster" : "https://<defaultClusterName>.<region>.kusto.windows.net"
}
```

In use the fields `controlBearerToken` and `dataBearerToken` will be added to the file
to cache the short lived bearer token values the control and data planes. These values are sensitive and should not be exposed.

| Field name          | Description |
|:--------------------|:------------|
| preferredAuthMethod | Indicated the authentication approach to use, e.g. clientSecret |
| tenantId            | Azure tenant ID |
| subscriptionId      | Azure subscriptions ID |
| clientId            | ID of the Application Registration used to connect to ADX |
| clientSecret        | Secret value corresponding to the clientId, this value is sensitive and should not be exposed |
| resourceGroup       | Azure resource group containing the ADX instance |
| database            | Default database name to use |
| cluster             | Default cluster name to use |

## Client Secret

Client Secret authentication is sometimes referred to as "Application Secret" as the
secrets created apply to Application Registrations. This package uses the term "Client
Secret or `clientSecret`as appropriate.

Client secret does not use the "Secret ID" value and it should not be confused with the
Client ID (sometimes called the App ID) or the Client Secret itself.

## BaseClient extension

The file `matlab-azure-adx/Software/MATLAB/app/system/+adx/+control/BaseClient.m`
implements the base client for the interface's API call classes.
In this file there are well commented hook points to which custom authentication
code can be integrated if required. This topic should be discussed with MathWorks
to clarify is custom code is necessary.

## Bearer Tokens

The lower-level `+api` classes and some higher-level functions accept an optional
argument `bearerToken` directly if the authentication process to obtain the token
is handled by some external means. Note that the KQL queries and management commands
will require different tokens as they use different endpoints.

## References

* Azure Services authentication [https://github.com/mathworks-ref-arch/matlab-azure-services/blob/main/Documentation/Authentication.md](https://github.com/mathworks-ref-arch/matlab-azure-services/blob/main/Documentation/Authentication.md)

[//]: #  (Copyright 2023-2024 The MathWorks, Inc.)
