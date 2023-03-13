# Blob Storage

Blob storage is the most common use case for Azure® Data Lake Storage Gen2. This
package provides a low-level interface to blob storage and provides capabilities
not available in shipping MATLAB. This package supersedes a previously published
blob storage low-level interface
[https://github.com/mathworks-ref-arch/matlab-azure-blob](https://github.com/mathworks-ref-arch/matlab-azure-blob).
Specifically this interface targets Gen2 storage APIs and the Azure v12 SDK
rather than the previous generation of APIs and the v8 SDK. While the older
interface referenced above provides some forward compatibility with Gen2 it is
strongly recommended that this interface be used when working with Gen2 blob
storage. While conceptually quite similar the APIs are not backwardly compatible
as a consequence of significant changes in the underlying Azure APIs.

## Blob Clients

The concept of a *Client* is central to how blob storage is accessed. A
hierarchy of clients exist that target different levels of the storage
hierarchy:

1. ```BlobServiceClient``` - This highest level client addresses the level of
   blob service itself.
2. ```BlobContainerClient``` - This client primarily supports operations at the
   container level.
3. ```BlobClient``` - The lowest level client supports operations at the blob
   level.

And there is a fourth `BlobLeaseClient` which can be used in conjunction with
`BlobContainerClient` or `BlobClient` for managing leases on blobs and
containers.

Client objects are created and configured using corresponding *Builder* objects.
There is overlap in functionality between the various clients and there may
often be more than one way to accomplish a given operation e.g. creating a
container.

Detailed information on the underlying client APIs can be found here: [Blob
Client
SDK](https://azuresdkartifacts.blob.core.windows.net/azure-sdk-for-java/staging/apidocs/index.html?com/azure/storage/blob/package-summary.html).
This interface exposes a subset of the available functionality to cover common
use cases in an extensible way.

A higher-level function *createStorageClient()* is provided to help build the
various clients, see: [DataLakeStorageGen2.md](DataLakeStorageGen2.md)

## Blob Service Client

A ```BlobServiceClient``` can be created using `createStorageClient` as follows:

```matlab
serviceClient = createStorageClient();
```

or build on a lower level using `BlobServiceClientBuilder`:

```matlab
% Create the client's builder
builder = azure.storage.blob.BlobServiceClientBuilder();

% configureCredentials is a convenience method that simplifies creating a credentials
% argument for the client's builder. In this case a Connection String is used to
% authenticate. Other authentication methods may required different build steps,
% e.g. setting an endpoint
credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'settings_ConnectionString.json'));
builder = builder.connectionString(credentials);

% Use a default Netty HTTP client and proxy settings as per MATLAB's proxy preferences
builder = builder.httpClient();

% The service client can now be built and then used
serviceClient = builder.buildClient();
```

### Common Service Client operations

For a full list of supported service client methods consult the API
documentation or call ```methods()``` on the client object or see the
[APIReference.md](APIReference.md) file.

```matlab
%% Listing containers

% Returns an array of BlobContainerItem objects that describe the containers in
% the current account
results = serviceClient.listBlobContainers();
% Assuming non-empty results show the name of the first container
results(1).getName()
```

```matlab
%% Create & Delete a container
% The service client creates a container with a given name an returns
% a corresponding BlobContainerObject
containerClient = serviceClient.createBlobContainer(containerName);

% We can use that client to test the container's existence
tf = containerClient.exists();

% The service client can the delete the container
serviceClient.deleteBlobContainer(containerName);

% Or alternatively the BlobContainerClient can do the deletion
containerClient.deleteContainer();
```

## Shared Access Signature Generation

In Azure, Shared Access Signatures or SASs are an important means of granting
access to resources via URLs and strings that are easily shared. There are
various types of SASs, see:

[https://docs.microsoft.com/en-us/rest/api/storageservices/delegate-access-with-shared-access-signature](https://docs.microsoft.com/en-us/rest/api/storageservices/delegate-access-with-shared-access-signature)

Which type of SAS you can generate depends on how the client is authenticated:

* When authenticated with [Storage Shared
  Key](Authentication.md#storage-shared-key) you can generate *account-level*
  and *service-level* SAS using `BlobServiceClient.generateAccountSas` and
  `BlobClient.generateSas`.

* When authenticated with [Connection
  String](Authentication.md#connection-string) (which is basically "using a
  SAS") or [with a SAS
  directly](#create-a-client-using-a-sas-for-authentication) you cannot
  *generate* any SAS at all but the SAS which you already have may simply be
  reusable.

* When authenticated using any other method (in which the client is essentially
  authenticated as a specific user or service principal) you can generate *user
  delegation* SAS.

The following example shows how to generate a *service-level* SAS for a
container:

```matlab
% Create a service client
builder = azure.storage.blob.BlobServiceClientBuilder();
credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'settings_StorageSharedKey.json'));
builder = builder.credential(credentials);
builder = builder.httpClient();
endpoint = ['https://', credentials.getAccountName(), '.blob.core.windows.net'];
builder = builder.endpoint(endpoint);
serviceClient = builder.buildClient();

% Define the access permissions to associate with the signature
permissions = azure.storage.common.sas.AccountSasPermission();
permissions = permissions.setListPermission(true);
permissions = permissions.setReadPermission(true);

% Define the resource type as a container
resourceTypes = azure.storage.common.sas.AccountSasResourceType();
resourceTypes = resourceTypes.setContainer(true);

% Define the Azure data services to which the SAS applies
services = azure.storage.common.sas.AccountSasService();
services = services.setBlobAccess(true);
services = services.setFileAccess(true);

% Set the expiry time of the SAS for 24 hours from now, note a timezone is required
expiryTime = datetime('now', 'TimeZone', 'UTC') + days(1);

% Create a AccountSasSignatureValues to combine the above values
sasValues = azure.storage.common.sas.AccountSasSignatureValues(expiryTime, permissions, services, resourceTypes);

% Create the SAS
% Note the service client must have been authenticated via a StorageSharedKeyCredential
% to allow it to generate a SAS
sas = serviceClient.generateAccountSas(sasValues);
```

And the following example shows how to generate a *user delegation* SAS for a
specific Blob:

```matlab
% Create a BlobClient using the convenience function (it is also possible
% to use the Builders). As an example a configuration for
% InteractiveBrowser authentication is used (any method which authenticates
% as user or service principal should do though).
blobClient = createStorageClient('ContainerName','my-container',...
    'BlobName','my-blob.txt',...
    'ConfigurationFile','myInteractiveBrowserSetting.json');

%% First obtain the UserDelegationKey using BlobServiceClient
% Obtain a service client for the given blob and its container
serviceClient = blobClient.getContainerClient.getServiceClient;
% Obtain a UserDelegationKey which is valid for, as an example, 1 hour
userKey = serviceClient.getUserDelegationKey(datetime('now'),...
    datetime('now')+hours(1));

%% Configure the desired permissions for the SAS
% Start with empty BlobSasPermission
permissions = azure.storage.blob.sas.BlobSasPermission();
% As an example, add read permissions
permissions = permissions.setReadPermission(true);
% Create the SAS signature, again for a validity of 1 hour
sasValues = azure.storage.blob.sas.BlobServiceSasSignatureValues(...
    datetime('now')+hours(1), permissions);

%% Generate the full signed SAS
sas = blobClient.generateUserDelegationSas(sasValues,userKey);

%% Do something with the SAS
% As an example now generate a full URL with which the blob can be accessed
% and which can be shared with others
URL = [blobClient.getBlobUrl '?' sas];

%% Or which can for example be used with copyFromUrl
% Create a blob client for a new blob
newBlobClient = createStorageClient('ContainerName','my-container',...
    'BlobName','copy-of-my-blob.txt',...
    'ConfigurationFile','myInteractiveBrowserSetting.json');
% And actually create it by copying the other blob
newBlobClient.copyFromUrl(URL);
```

## Blob Container Client

A *BlobContainerClient* appears very similar to a service client both in
creation and operation.

```matlab
% Create using createStorageClient
containerClient = createStorageClient('ContainerName','mycontainername');
```

or:

```matlab
% Create the Client using its builder
builder = azure.storage.blob.BlobContainerClientBuilder();

% Again using connection string based authentication
credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'settings_ConnectionString.json'));

builder = builder.connectionString(credentials);
builder = builder.httpClient();
builder = builder.containerName("mycontainername");
containerClient = builder.buildClient();
```

### Common Container Client operations

#### List blobs in a container

```matlab
% With the client in place it can be used to list the blobs within its corresponding
% container

% List the blobs in the container
results = containerClient.listBlobs;
% Display the name of the 1st blob assuming the container is not empty
results(1).getName()
```
See also [Advanced listing support](#advanced-listing-support) below.

#### Create a BlobClient

```matlab
% Get a blob name and create a client using it
results = containerClient.listBlobs;
% Assume there is a blob with name:
results(1).getName();

% Create the corresponding BlobClient
blobClient = client.getBlobClient(results(1).getName());
```

## Blob Client

The *BlobClient* appears very similar to the other clients in creation and
operation.

```matlab
% Create using createStorageClient
containerClient = createStorageClient('ContainerName','mycontainername',...
   'BlobName','myblobname.txt');
```

or:

```matlab
% Create the client builder
builder = azure.storage.blob.BlobClientBuilder();

% Configure the builder
credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'settings_ConnectionString.json'));
builder = builder.connectionString(credentials);
builder = builder.httpClient();
builder = builder.containerName("mycontainername");
builder = builder.blobName("myblobname.txt");

% Create the client
blobClient = builder.buildClient();
```

### Common Blob Client operations

#### Test if a blob exists

```matlab
tf = blobClient.exists();
```

#### Get a URL for a blob

```matlab
urlStr = blobClient.getBlobUrl();
```

#### Create a client using a SAS for authentication

```matlab
builder = azure.storage.blob.BlobClientBuilder();
builder = builder.sasToken(sas);
builder = builder.httpClient();
builder = builder.endpoint(endpoint);
builder = builder.containerName("mycontaintername");
builder = builder.blobName("myblobname.txt");
blobClient = builder.buildClient();
```

#### Upload & download a blob

```matlab
uploadFile = 'C:\mydir\myfile.mat';
[~, fileName, ext] = fileparts(uploadFile);
% The blob name and filename need not match but they typically do
blobName = [fileName, ext];
builder = azure.storage.blob.BlobClientBuilder();
builder = builder.connectionString(credentials);
builder = builder.httpClient();
builder = builder.containerName('mycontainername');
builder = builder.blobName(blobName);
blobClient = builder.buildClient();

% Upload the file to the blob overwriting any existing blob of that name
blobClient.uploadFromFile(uploadFile, 'overwrite', true);

% Download the blob to a temporary location
downloadFile = [tempname,'.mat'];
blobClient.downloadToFile(downloadFile, 'overwrite', true);
```

#### Copy a blob using a SAS

```matlab
% Create a client for the source blob
builder = azure.storage.blob.BlobClientBuilder();
credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'settings_StorageSharedKey.json'));
builder = builder.credential(credentials);
builder = builder.httpClient();
builder = builder.containerName("sourcecontainer");
builder = builder.blobName("sourceblob.txt");
srcClient = builder.buildClient();

% Create a service-level read only SAS valid for 24 hours
permissions = azure.storage.blob.sas.BlobSasPermission();
permissions = permissions.setReadPermission(true);
expiryTime = datetime('now', 'TimeZone', 'UTC') + days(1);
sasValues = azure.storage.blob.sas.BlobServiceSasSignatureValues(expiryTime, permissions);
srcSas = srcClient.generateSas(sasValues);

% Build the full SAS URL by appending the SAS to the blob URL, note the '?'
srcUrl = srcClient.getBlobUrl();
srcStr = append(srcUrl, '?', srcSas);

% Create a container & respective client for the destination blob
builder = azure.storage.blob.BlobContainerClientBuilder();
credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'settings_ConnectionString.json'));
builder = builder.connectionString(credentials);
builder = builder.httpClient();
builder = builder.containerName("destinationcontainer");
containerClient = builder.buildClient();
containerClient.create();
destClient = containerClient.getBlobClient('destinationblob.txt');

% Finally copy the source blob to the destination
destClient.copyFromUrl(srcStr);
```

## Blob Lease Client

`BlobLeaseClient` is created using `BlobLeaseClientBuilder` which can then build
the client based on an existing `BlobClient` or `BlobContainerClient`.
Optionally the `BlobLeaseClient` can be configured with a specific leaseId (e.g.
in order to then be able to release a lease previously created outside of MATLAB
or for which the `BlobLeaseClient` was cleared).

```matlab
% Create BlobLeaseClient based on an existing BlobClient 
% 'existingBlobClient' (created using the instructions above)
builder = azure.storage.blob.specialized.BlobLeaseClientBuilder;
builder = builder.blobClient(existingBlobClient);
% Optionally specify a specific leaseId
builder = builder.leaseId('60233c25-dc52-4b3a-a874-dc641b4877a9');

% Build the BlobLeaseClient
leaseClient = builder.buildClient();
```

```matlab
% Create BlobLeaseClient based on an existing BlobContainerClient 
% 'existingContainerClient' (created using the instructions above)
builder = azure.storage.blob.specialized.BlobLeaseClientBuilder;
builder = builder.containerClient(existingContainerClient);
% Optionally specify a specific leaseId
builder = builder.leaseId('60233c25-dc52-4b3a-a874-dc641b4877a9');

% Build the BlobLeaseClient
leaseClient = builder.buildClient();
```

### Acquiring, renewing, changing, releasing and breaking leases

The interface supports all Lease Blob operations as specified in the [Azure
documentation](https://docs.microsoft.com/en-us/rest/api/storageservices/lease-blob).

```matlab
% Acquire a lease for 30 seconds
leaseId = leaseClient.acquireLease(30);
% Acquire a lease which never expires
leaseId = leaseClient.acquireLease(-1);
% Renew an active lease
leaseClient.renewLease();
% Change a lease to a different leaseId
leaseClient.changeLease('195aaa29-d604-469b-93a4-80af769f4b03')
% Release an active lease
leaseClient.releaseLease();
% Break a lease
leaseClient.breakLease();
```

### Interacting with a Blob or Blob Container which has a lease on it

When a Blob has a lease on it, certain interactions like deleting it or
overwriting it with a newly uploaded or copied file are only possible when that
operation is performed with the correct leaseId. The leaseId can be provided as
Name-Value input pair to the `deleteBlob`, `uploadFromFile` and `copyFromFile`
methods of `BlobClient` and the `deleteContainer` method of
`BlobContainerClient`. So a full workflow could become:

```matlab
% Build a BlobClient
blobClient = createStorageClient('ContainerName','mycontainer','BlobName','myblob');

% Build a BlobLeaseClient based on this BlobClient
leaseClientBuilder = azure.storage.blob.specialized.BlobLeaseClientBuilder;
leaseClientBuilder = leaseClientBuilder.blobClient(blobClient);

leaseClient = leaseClientBuilder.buildClient();

% Acquire a lease
leaseId = leaseClient.acquireLease(-1);

% Upload a new file to overwrite the blob
blobClient.uploadFromFile('myfile.txt','overwrite',true,'leaseId',leaseId);

% Delete the blob while the lease is active
blobClient.deleteBlob('leaseId',leaseId);
```

### Advanced listing support

A basic listing of a container's contents can be done as follows:

```matlab
% Get a blob name and create a client using it
results = containerClient.listBlobs;
% Assume there is a blob with name:
results(1).getName();
```

This returns an array of BlobItems in a container, with folder structures flattened. The Java PagedIterable is consumed by the MATLAB `listBlobs` methods, while convenient this makes the method unsuitable for use with containers with very large numbers of blobs. Blob names are returned in lexicographic order.

The `BlobItem.isPrefix` method can be used to determine if an entry is a directory or not.

It is sometimes necessary to provide a more advanced query. This can be done using the following additions:

* A directory name prefix
* An `azure.storage.blob.models.BlobListDetails` object
* An `azure.storage.blob.models.ListBlobsOptions` object

#### Using a prefix/directory

`BlobContainerClient.listBlobsByHierarchy(directory)` Returns all the blobs and directories (prefixes) under the given directory (prefix). Directories will have `BlobItem.isPrefix()` set to true. Blob names are returned in lexicographic order. E.g. listing a container containing a 'foo' folder, which contains blobs 'foo1' and 'foo2', and a blob on the root level 'bar', will return the following results when prefix/directory is not set.

* foo/ (isPrefix = true)
* bar (isPrefix = false)

And will return the following results when prefix="foo/":

* foo/foo1 (isPrefix = false)
* foo/foo2 (isPrefix = false)

Alternatively the following arguments can be provided `BlobContainerClient.listBlobsByHierarchy(delimiter, options, timeout)`:

* delimiter - The delimiter for blob hierarchy, "/" for hierarchy based on directories. "/" should be used in almost all circumstances.
* options - `ListBlobsOptions`, see below.
* timeout - A number of seconds timeout value beyond which a runtime exception will be raised.

#### ListBlobsOptions

A `ListBlobsOptions` object allows the following criteria to be set:

* `setDetails(blobListDetails)` further options see below.
* `setMaxResultsPerPage(maxResultsPerPage)` Specifies the maximum number of blobs to return, including all BlobPrefix elements. In practice the list methods consume the iterators, so unless working directly with the Java Handle methods this should be ignored.
* `setPrefix(prefix)` Filters the results to return only blobs whose names begin with the specified prefix.

`set` methods return an updated `ListBlobsOptions` object. `get` methods are also provided.

#### BlobListDetails

Allows specifying of additional information to be returned with each blob when listing blobs in a container (via a BlobContainerClient object). This type is immutable to ensure thread-safety of requests, so changing the details for a different listing operation requires construction of a new object.

`get` methods return logicals and `set` methods return an updated `BlobListDetails` object.

* `getRetrieveCopy()` Whether blob metadata related to any current or previous Copy Blob operation should be included in the response.
* `getRetrieveDeletedBlobs()` Whether blobs which have been soft deleted should be returned.
* `getRetrieveDeletedBlobsWithVersions()` Whether blobs which have been deleted with versioning.
* `getRetrieveImmutabilityPolicy()` Whether immutability policy for the blob should be returned.
* `getRetrieveLegalHold()` Whether legal hold for the blob should be returned.
* `getRetrieveMetadata()` Whether blob metadata should be returned.
* `getRetrieveSnapshots()` Whether snapshots should be returned.
* `getRetrieveTags()` Whether blob tags should be returned.
* `getRetrieveUncommittedBlobs()` Whether blobs for which blocks have been uploaded, but which have not been committed using Put Block List, should be included in the response.
* `getRetrieveVersions()` Whether versions should be returned.

### Blob properties & metadata

A blob's properties can be queried reason about the blob, e.g. check its MD5 or size.
In this case the file/object is 0 bytes in size.

```matlabsession
>> myBlob = l(1)
myBlob = 
  BlobItem with no properties.
>> myProps = myBlob.getProperties;
>> myProps.getContentMd5
ans =
    '1B2M2Y8AsgTpgAmY7PhCfg=='
>> myProps.getContentLength
ans =
  int64
   0
```

Use `methods()` on a properties object to explore the available data.

```{note}
`properties` is a reserved word in MATLAB and should not be used as a variable name etc.
```

In this case the blob has no available metadata, an empty containers.Map is returned:

```matlab
% Create a Container client
client = builder.buildClient();
% Create a BlobListDetails to control what blob details are returned when listing
b = azure.storage.blob.models.BlobListDetails();
% Enable Metadata & Tags
b = b.setRetrieveMetadata(true);
b = b.setRetrieveTags(true);
% Create a ListBlobsOptions to hold the BlobListDetails
l = azure.storage.blob.models.ListBlobsOptions();
lnew = l.setDetails(b);

% Return a list of blobs, "/" is teh delimiter and 60 is a timeout in seconds
l = client.listBlobsByHierarchy("/", lnew, 60);

% Pick one of the returned blobs
myBlob = l(1);
% Get the Metadata
md = myBlob.getMetadata
md = 
  Map with properties:
        Count: 1
      KeyType: char
    ValueType: char
% Display the containers.Map content in this case a tag
md.keys
ans =
  1×1 cell array
    {'barMetadataKey'}
K>> md.values
ans =
  1×1 cell array
    {'barMetadataVal'}

% Get the tag directly and display the containers.Map content
tags = myBlob.getTags
tags = 
  Map with properties:
        Count: 1
      KeyType: char
    ValueType: char
tags.keys
ans =
  1×1 cell array
    {'barMetadataKey'}
tags.values
ans =
  1×1 cell array
    {'barMetadataVal'}
```


For more information, see [https://azuresdkdocs.blob.core.windows.net/$web/java/azure-storage-blob/12.21.0/com/azure/storage/blob/BlobContainerClient.html#listBlobs()](https://azuresdkdocs.blob.core.windows.net/$web/java/azure-storage-blob/12.21.0/com/azure/storage/blob/BlobContainerClient.html#listBlobs())

[//]: #  (Copyright 2020-2023 The MathWorks, Inc.)
