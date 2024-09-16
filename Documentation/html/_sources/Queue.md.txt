# Queue Storage

QueueStorage is designed to provide durable message queueing for large
workloads. This package provides a low-level interface to queue storage and
provides capabilities not available in shipping MATLAB. This package supersedes
a previously published blob storage low-level interface
[https://github.com/mathworks-ref-arch/matlab-azure-blob](https://github.com/mathworks-ref-arch/matlab-azure-blob).
Specifically this interface target's Gen2 storage APIs and the Azure® v12 SDK
rather than the previous generation of APIs and the v8 SDK. While older
interface referenced above provides some forward compatibility with Gen2 it is
strongly recommended that this interface be used when working with Gen2 blob
storage. While conceptually quite similar the APIs are not backwardly compatible
as a consequence of significant changes in the underlying Azure APIs.

## Queue Clients

The concept of a *Client* is central to how queue storage is accessed. A
hierarchy of clients exist that target different levels of the storage
hierarchy:

1. ```QueueServiceClient``` - This highest level client addresses the level of
   queue service itself.
2. ```QueueClient``` - The lowest level client supports operations at the queue
   level.

Client objects are created and configured using corresponding *Builder* objects.
There is overlap in functionality between the various clients and there may
often be more than one way to accomplish a given operation.

Detailed information on the underlying client APIs can be found here: [Queue Client SDK](https://azuresdkartifacts.blob.core.windows.net/azure-sdk-for-java/staging/apidocs/index.html?com/azure/storage/queue/package-summary.html).
This interface exposes a subset of the available functionality to cover common
use cases in an extensible way.

A higher-level function *createStorageClient()* is provided to help build the
various clients.

## `createStorageClient` function

See the [`createStorageClient` description](DataLakeStorageGen2.md#createstorageclient-function) for more details.

## Queue Service Client

A ```QueueServiceClient``` can be created using `createStorageClient` as
follows:

```matlab
qsc = createStorageClient('Type','QueueService');
```

or build on a lower level using `QueueServiceClientBuilder`:

```matlab
% Create the client's builder
builder = azure.storage.queue.QueueServiceClientBuilder();

% configureCredentials is a function that simplifies creating a credentials
% argument for the client's builder. In this case a Connection String is used to
% authenticate. Other authentication methods may required different build steps,
% e.g. setting an endpoint
credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'settings_ConnectionString.json'));
builder = builder.connectionString(credentials);

builder = builder.httpClient();
qsc = builder.buildClient();
```

### Common Service Client operations

For a full list of supported service client methods consult the API
documentation or call ```methods()``` on the client object or see the
[APIReference.md](APIReference.md) file.

```matlab
% Create a Queue & its client
queueClient = qsc.createQueue('myqueuename');
```

```matlab
% List queues
qList = qsc.listQueues();
```

```matlab
% Delete a Queue & its client
qsc.deleteQueue('myqueuename');
```

## Queue Client

A ```QueueClient``` is created as follows:

```matlab
% Create using createStorageClient
qc = createStorageClient('QueueName','myquename-123456');
```

or:

```matlab
% Create the Client's builder
builder = azure.storage.queue.QueueClientBuilder();

credentials = configureCredentials(fullfile(AzureCommonRoot, 'config', 'settings_ConnectionString.json'));

builder = builder.connectionString(credentials);
builder = builder.httpClient();
builder = builder.queueName("myquename-123456");
qc = builder.buildClient();
    
```

### Common Queue Client operations

```matlab
% Send a message
msgResult = qc.sendMessage('my test message');
receipt = msgResult.getPopReceipt;

```

```matlab
% Get insertion, expiration & next visible times
insertTime = msgResult.getInsertionTime();
expireTime = msgResult.getExpirationTime();
visibleTime = msgResult.getTimeNextVisible();

```

```matlab
% Receive a message
msg = qc.receiveMessage();
```

```matlab
% Get insertion, expiration & next visible times
insertTime = msg.getInsertionTime();
expireTime = msg.getExpirationTime();
visibleTime = msg.getTimeNextVisible();
```

```matlab
% Get the message count, id and receipt
count = msg.getDequeueCount();
id = msg.getMessageId();
receipt = msg.getPopReceipt;
```

```matlab
% Get the message text itself
text = msg.getMessageText();
```

```matlab
% Clear all or delete a single message
qc.clearMessages();
qc.deleteMessage(id, receipt);
```

[//]: #  (Copyright 2022 The MathWorks, Inc.)
