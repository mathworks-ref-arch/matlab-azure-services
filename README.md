# MATLAB Interface *for Azure Services*

This package provides MATLAB® interfaces that connect to various Microsoft Azure®
Services, it currently supports:

* [Azure Data Lake Storage Gen2](https://mathworks-ref-arch.github.io/matlab-azure-services/DataLakeStorageGen2.html)
* [Azure Key Vault](https://mathworks-ref-arch.github.io/matlab-azure-services/KeyVault.html)
* [Azure Data Explorer](https://mathworks-ref-arch.github.io/matlab-azure-services/DataExplorer.html)

> Note, very many of MATLAB's IO operations support Blob Storage via builtin functions.
> For example `dir` supports accessing remote data:
>
> * [https://www.mathworks.com/help/matlab/ref/dir.html](https://www.mathworks.com/help/matlab/ref/dir.html)
> * [https://www.mathworks.com/help/matlab/import_export/work-with-remote-data.html](https://www.mathworks.com/help/matlab/import_export/work-with-remote-data.html)
>
> Where MATLAB supports the required operations, it is recommended to use the builtin
> support, particularly in preference to this package's Azure Data Lake Storage Gen2
> lower level capabilities.

## Requirements

* [MathWorks®](http://www.mathworks.com) Products
  * MATLAB® R2019a or later
  * MATLAB® R2021a or later if using Azure Data Explorer
* 3rd party products (Required to build the Azure SDK jar file)
  * Maven™ 3.6.1 or later
  * JDK v8 or greater and less than v18

## Documentation

The primary documentation for this package is available at: [https://mathworks-ref-arch.github.io/matlab-azure-services](https://mathworks-ref-arch.github.io/matlab-azure-services)

## Usage

Once [installed](https://mathworks-ref-arch.github.io/matlab-azure-services/Installation.html)
the interface can be added to the MATLAB path by running `startup.m` from the `Software/MATLAB` directory.
Also refer to configuration and authentication details below.

## Azure Data Lake Storage Gen2 examples

### Create a Blob Client and check if a blob exists

```matlab
blobClient = createStorageClient('ContainerName','myContainer','BlobName','myBlob') 
tf = blobClient.exists();
```

### Acquire a lease for a blob

```matlab
builder = azure.storage.blob.specialized.BlobLeaseClientBuilder;
builder = builder.blobClient(blobClient);
% Build the BlobLeaseClient
leaseClient = builder.buildClient();
% Acquire a lease for 30 seconds
leaseId = leaseClient.acquireLease(30)
```

### Create Queue Service Client and create a queue

```matlab
queueServiceClient = createStorageClient('Type','QueueService');
queueClient = queueServiceClient.createQueue('myqueuename');
```

### Create File Data Lake (file) Client and check if the file exists

```matlab
dataLakeFileClient = createStorageClient('FileSystemName','myFileSystem',...
               'FileName','my/dir/file');
tf = dataLakeFileClient.exists();
```

For further details see: [Azure Data Lake Storage Gen2](https://mathworks-ref-arch.github.io/matlab-azure-services/DataLakeStorageGen2.html)

## Azure Key Vault

### Create a Secret Client and get a secret value

```matlab
secretClient = createKeyVaultClient('Type','Secret');
% Get the secret using its name
secret = secretClient.getSecret('mySecretName');
% Get the secret value
secretValue = secret.getValue();
```

### List keys in a vault

```matlab
% Create a client
keyClient = createKeyVaultClient('Type','Key');
% Get an array of secret properties
properties = keyClient.listPropertiesOfKeys();
% Get the name property for the first entry
name = propList(1).getName();
```

For further details see: [Azure Key Vault](https://mathworks-ref-arch.github.io/matlab-azure-services/KeyVault.html)

## Azure Data Explorer

This package provides access to Azure Data Explorer related features from within MATLAB.
Lower-level interfaces to the Azure Data Explorer REST APIs are provided along with
some higher-level interfaces for common tasks.
The Control plane REST API client is automatically generated based upon the OpenAPI spec.
provided in [https://github.com/Azure/azure-rest-api-specs/tree/main/specification](https://github.com/Azure/azure-rest-api-specs/tree/main/specification).

### Return "Hello World" using a Kusto query

```matlab
>> [result, success] = mathworks.adx.run('print myColumn="Hello World"')
result =
  table
      myColumn    
    _____________
    "Hello World"
success =
  logical
   1
```

### A query to count the number of rows in a table

```matlab
>> rowCount = mathworks.adx.run(sprintf("myTableName | count", tableName))
rowCount =
  table
    Count 
    ______
    123523
```

### Return some rows in a table

```matlab
>> firstRows = mathworks.adx.run("myTableName | take 5")
firstRows =
  5x27 table
       Date        DayOfWeek          DepTime                CRSDepTime
    ___________    _________    ____________________    ____________________
    21-Oct-1987        3        21-Oct-1987 06:42:00    21-Oct-1987 06:30:00
    26-Oct-1987        1        26-Oct-1987 10:21:00    26-Oct-1987 10:20:00
    23-Oct-1987        5        23-Oct-1987 20:55:00    23-Oct-1987 20:35:00
    23-Oct-1987        5        23-Oct-1987 13:32:00    23-Oct-1987 13:20:00
    22-Oct-1987        4        22-Oct-1987 06:29:00    22-Oct-1987 06:30:00
```

## Configuration & authentication

While the packages share some common configuration and authentication code they
also have separate configuration details to record preferred default endpoints
and authentication methods.

### Azure Data Lake Storage Gen2 & Azure Key Vault setup

First change to the `matlab-azure-services/Software/MATLAB` directory and run the
startup command to configure paths.

The package offers a `loadConfigurationSettings` function which allows reading
configuration settings from a short JSON format file. This offers a convenient
way for you to configure various settings (like endpoint URLs) as well as
authentication configurations without having to hardcode these into your MATLAB
code. For more details see: [Configuration](https://mathworks-ref-arch.github.io/matlab-azure-services/Configuration.html)

Virtually all interactions with Azure will require some form of authentication.
The package offers various Builder classes as well as a higher-level function
`configureCredentials` to aid performing the authentication. For more details
see: [Authentication](https://mathworks-ref-arch.github.io/matlab-azure-services/Authentication.html)

### Azure Data Explorer setup

First change to the `matlab-azure-services/Software/MATLAB` directory and run the
startup command to configure paths.

Initially run `mathworks.adx.buildSettingsFile`, to configure credentials & settings.
For more details see: [ADXAuthentication.md](Documentation/ADXAuthentication.md).
A number of authentication methods are supported.

Assuming Client Secret authentication, the simplest to configure, this should result
in a file: `Software/MATLAB/config/adx.Client.Settings.json` similar to:

```json
{
    "preferredAuthMethod" : "clientSecret",
    "subscriptionId" : "<REDACTED>",
    "tenantId" : "<REDACTED>",
    "clientId" : "<REDACTED>",
    "clientSecret" : "<REDACTED>",
    "database" : "<defaultDatabaseName>",
    "resourceGroup": "<resourceGroupName>",
    "cluster" : "https://<defaultClusterName>.<region>.kusto.windows.net"
}
```

## License

The license for the MATLAB Interface for Azure Services is available in the
[License.txt](License.txt) file in this repository. This package uses certain
third-party content which is licensed under separate license agreements.
See the pom.xml in the `Software/Java` directory of this package for details of
third-party software downloaded at build time.

## Enhancement Request

Provide suggestions for additional features or capabilities using the following
link: [https://www.mathworks.com/products/reference-architectures/request-new-reference-architectures.html](https://www.mathworks.com/products/reference-architectures/request-new-reference-architectures.html)

## Support

Please create a GitHub issue.

Microsoft Azure Data Explorer, Azure Data Lake Storage & Azure Key Vault are trademarks of the Microsoft group of companies.

[//]: #  (Copyright 2021-2024 The MathWorks, Inc.)
