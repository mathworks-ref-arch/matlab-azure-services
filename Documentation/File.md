# File Data Lake Storage

The File Data Lake API currently has less implemented functionality than the equivalent
Blob and Queue APIs, where additional API calls are needed contact MathWorks.

Relevant Azure® API/service documentation:

* [https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction)
* [https://docs.microsoft.com/en-us/java/api/overview/azure/storage-file-datalake-readme?view=azure-java-stable](https://docs.microsoft.com/en-us/java/api/overview/azure/storage-file-datalake-readme?view=azure-java-stable)

## File Data Lake Clients

The concept of a *Client* is central to how file storage is accessed. A
hierarchy of clients exist that target different levels of the storage
hierarchy:

1. Path
2. Filesystem
3. Directory
4. File

## High-level Client Creation

As with other services both high-level and low-level approaches for creating
various clients are supported.

```matlab
% creates a DataLakeFileSystemClient with default options
client = createStorageClient('FileSystemName','myFileSystem');
```

```matlab
% Creates a DataLakeDirectoryClient with default options
client = createStorageClient('FileSystemName','myFileSystem',...
               'DirectoryName','my/dir');
```

```matlab
%  Creates a DataLakeFileClient with default options
client = createStorageClient('FileSystemName','myFileSystem',...
               'FileName','my/dir/file');
```

Additional Name, Value pairs can be supplied to configure non-default options. See: ```doc createStorageClient``` for more details.

## URL Format

File path are addressable using the following URL format:

```https://myaccount.dfs.core.windows.net/myfilesystem/myfilepath```

Filesystems can be thought of as being similar to Blob Containers and Paths for
files or Directories as being similar to Blobs.

## Build a Filesystem Client

```matlab
% Read a shared storage key from a file
credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'myStorageSharedKey.json'));

% Create a filesystem builder
builder = azure.storage.file.datalake.DataLakeFileSystemClientBuilder();

% Configure the builder's credentials, http client, endpoint and name
builder = builder.credential(credentials);
builder = builder.httpClient();
endpoint = ['https://', credentials.getAccountName(), '.dfs.core.windows.net'];
builder = builder.endpoint(endpoint);
builder = builder.fileSystemName("myfilesystemname");

% Build the client
client = builder.buildClient();
```

A very similar Path class, ```azure.storage.file.datalake.DataLakePathClientBuilder()``` exists.

## Build a Filesystem Client to work with SASs

```matlab
% Create some minimal permissions
FSSP = azure.storage.file.datalake.sas.FileSystemSasPermission();
FSSP = FSSP.setListPermission(true);
FSSP = FSSP.setReadPermission(true);

% Set the SAS to expire in 1 days 
expiryTime = datetime('now', 'TimeZone', 'UTC') + days(1);
DLSSSV = azure.storage.file.datalake.sas.DataLakeServiceSasSignatureValues(expiryTime, FSSP);

% Requires a shared storage key based client for SAS generation
credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'myStorageSharedKey.json'));

% Build the client previously shown
builder = azure.storage.file.datalake.DataLakeFileSystemClientBuilder();
builder = builder.credential(credentials);
endpoint = ['https://', credentials.getAccountName(), '.dfs.core.windows.net'];
builder = builder.endpoint(endpoint);
builder = builder.httpClient();
builder = builder.fileSystemName("myfilesystemname");
client = builder.buildClient();

% Use the client to generate a SAS
sasToken = client.generateSas(DLSSSV);

% Return an array of azure.storage.file.datalake.models.PathItem
% detailing filesystem contents
paths = client.listPaths();

% Build a second client authenticated with the previoulsy creates SAS
builder2 = azure.storage.file.datalake.DataLakeFileSystemClientBuilder();
builder2 = builder2.sasToken(sasToken);
endpoint = ['https://', credentials.getAccountName(), '.dfs.core.windows.net'];
builder2 = builder2.endpoint(endpoint);
builder2 = builder2.httpClient();
builder2 = builder2.fileSystemName("myfilesystemname");
client2 = builder2.buildClient();

% Perform an operation using it
paths = client2.listPaths();
```

## SAS Permissions

A *Path* SAS Permission is created as follows:

```matlab
psp = azure.storage.file.datalake.sas.PathSasPermission();
```

By default all permissions are disabled and the following methods return false:

```matlab
psp.hasAddPermission();
psp.hasCreatePermission();
psp.hasDeletePermission();
psp.hasExecutePermission();
psp.hasListPermission();
psp.hasManageAccessControlPermission();
psp.hasManageOwnershipPermission();
psp.hasMovePermission();
psp.hasReadPermission();
psp.hasWritePermission();
```

There are corresponding set permission methods that accept a logical and return
and updated permission:

```matlab
psp = psp.setCreatePermission(true);
```

A *File System* permission class with very similar functionality also exists:

```matlab
fssp = azure.storage.file.datalake.sas.FileSystemSasPermission();
```

## Directory Clients & misc. operations

```matlab
% Begin by creating a Path Client
builder = azure.storage.file.datalake.DataLakePathClientBuilder();
credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'myStorageSharedKey.json'));
builder = builder.credential(credentials);
endpoint = ['https://', credentials.getAccountName(), '.dfs.core.windows.net'];
builder = builder.endpoint(endpoint);
builder = builder.httpClient();
builder = builder.fileSystemName("myfilesystemname");
builder = builder.pathName('mydirectoryname');
dirClient = builder.buildDirectoryClient();

% Check if the path exists
tf = Client.exists();

% Create a Directory Client from a Filesystem Client
builder = azure.storage.file.datalake.DataLakeFileSystemClientBuilder();
credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'myStorageSharedKey.json'));
builder = builder.credential(credentials);
endpoint = ['https://', credentials.getAccountName(), '.dfs.core.windows.net'];
builder = builder.endpoint(endpoint);
builder = builder.httpClient();
builder = builder.fileSystemName("myfilesystemname");
fsClient = builder.buildClient();

% Create Directory Client
existingDirClient = fsClient.createDirectory('myOtherDirectory', true);

% Return the path & URL
path = existingDirClient.getDirectoryPath();
url = existingDirClient.getDirectoryUrl();

% Delete the directory
existingDirClient.deleteDirectory();

% Create and Delete a subdirectory on the filesystem
level1DirClient = fsClient.createDirectory('level1', true);
level2DirClient = fsClient.createDirectory('level1/level2', true);
level1DirClient.deleteSubdirectory('level2');
% verify using an exists() method
level2DirClient.exists();

% Create a File
level1DirClient = fsClient.createDirectory('level1', true);
level1FileClient = level1DirClient.createFile('tmpFile.txt', true);
            
% Rename a directory from srcDir to dstDir
srcDirClient = fsClient.createDirectory('srcDir', true);
nullVal = [];
renamedDirClient = srcDirClient.rename(nullVal, 'dstDir');
```

## Notes

This API does not support storage accounts where hierarchical namespace (HNS) is disabled.

[//]: #  (Copyright 2022-2024 The MathWorks, Inc.)
