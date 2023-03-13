# MATLAB Interface *for Azure Services*

## Introduction

This package offers MATLAB™ interfaces that connect to various Microsoft Azure®
Services it currently supports:

* [Azure Data Lake Storage Gen2](https://mathworks-ref-arch.github.io/matlab-azure-services/DataLakeStorageGen2.html)
* [Azure Key Vault](https://mathworks-ref-arch.github.io/matlab-azure-services/KeyVault.html)

> Note, very many of MATLAB's IO operations support Blob Storage via builtin functions.
> For example ```dir``` supports accessing remote data:
>
> * [https://www.mathworks.com/help/matlab/ref/dir.html](https://www.mathworks.com/help/matlab/ref/dir.html),
> * [https://www.mathworks.com/help/matlab/import_export/work-with-remote-data.html](https://www.mathworks.com/help/matlab/import_export/work-with-remote-data.html).
>
> Where MATLAB supports the required operations directly that is the recommended
> approach.

## Requirements

* [MathWorks®](http://www.mathworks.com) Products
  * MATLAB® release R2019a or later
  * (optional) MATLAB Compiler™ and Compiler SDK™
  * (optional) MATLAB Production Server™
  * (optional) MATLAB Parallel Server™
* 3rd party products
  * Maven™ 3.6.1 or later
  * JDK 8 or later

This package is primarily tested using Ubuntu™ 20.04 and Windows® 11.

## Documentation

The main documentation for this package is available at:

<https://mathworks-ref-arch.github.io/matlab-azure-services>

## Usage

Once [installed](https://mathworks-ref-arch.github.io/matlab-azure-services/Installation.html) the interface is added to the MATLAB path
by running `startup.m` from the `Software/MATLAB` directory.

### Azure Data Lake Storage Gen2

#### Create a Blob Client and check if a blob exists

```matlab
blobClient = createStorageClient('ContainerName','myContainer','BlobName','myBlob') 
tf = blobClient.exists();
```

#### Acquire a lease for a blob

```matlab
builder = azure.storage.blob.specialized.BlobLeaseClientBuilder;
builder = builder.blobClient(blobClient);
% Build the BlobLeaseClient
leaseClient = builder.buildClient();
% Acquire a lease for 30 seconds
leaseId = leaseClient.acquireLease(30)
```

#### Create Queue Service Client and create a queue

```matlab
queueServiceClient = createStorageClient('Type','QueueService');
queueClient = queueServiceClient.createQueue('myqueuename');
```

#### Create File Data Lake (file) Client and check if the file exists

```matlab
dataLakeFileClient = createStorageClient('FileSystemName','myFileSystem',...
               'FileName','my/dir/file');
tf = dataLakeFileClient.exists();
```

For further details see: [Azure Data Lake Storage Gen2](https://mathworks-ref-arch.github.io/matlab-azure-services/DataLakeStorageGen2.html)

### Azure Key Vault

#### Create a Secret Client and get a secret value

```matlab
secretClient = createKeyVaultClient('Type','Secret');
% Get the secret using its name
secret = secretClient.getSecret('mySecretName');
% Get the secret value
secretValue = secret.getValue();
```

#### List keys in a vault

```matlab
% Create a client
keyClient = createKeyVaultClient('Type','Key');
% Get an array of secret properties
properties = keyClient.listPropertiesOfKeys();
% Get the name property for the first entry
name = propList(1).getName();
```

For further details see: [Azure Key Vault](https://mathworks-ref-arch.github.io/matlab-azure-services/KeyVault.html)

### Configuration

The package offers a `loadConfigurationSettings` function which allows reading
configuration settings from a short JSON format file. This offers a convenient
way for you to configure various settings (like endpoint URLs) as well as
authentication configurations without having to hardcode these into your MATLAB
code. For more details see: [Configuration](https://mathworks-ref-arch.github.io/matlab-azure-services/Configuration.html)

### Authentication

Virtually all interactions with Azure will require some form of authentication.
The authentication workflows are common to all services. The package offers
various Builder classes as well as a higher-level function `configureCredentials`
to aid performing the authentication. For more details see: [Authentication](https://mathworks-ref-arch.github.io/matlab-azure-services/Authentication.html)

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

[//]: #  (Copyright 2021-2022 The MathWorks, Inc.)
