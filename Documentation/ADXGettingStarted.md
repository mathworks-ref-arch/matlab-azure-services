# Getting Started

Azure Data Explorer (ADX) commands can be broadly separated into two classes:

* Data queries, which transact data on the platform
* Control queries, which relate to the platform itself

This document will describe some examples of each and how they are structured.
It does not attempt to cover the complete KQL syntax or all of the control options
that are available. For further detailed refer to the [API reference](ADXAPI.md)
and Azure's documentation.

The following examples assume that the package has previously been configured with
connection and authentication details, see: [ADXAuthentication](ADXAuthentication.md).

The REST API interface used by this package can be somewhat verbose in some cases
once familiar with its behavior it is generally straightforward to create wrapper
functions in MATLAB that more concisely address a task. Some such reference implementations
are provided.

> MathWorks reserves the `internal` namespace and functions within this namespace
> are subject to change or removal without notice and should not be used.

## Data queries

### Hello World KQL query

#### `run` command

The following reference implementation `mathworks.adx.run` is a high-level
wrapper that abstracts the different types of queries under a generic `run` method.
For more advanced use cases it may be required to drop to the lower-level interfaces
described below.

The query requests that "Hello World" be printed. This is returned as a table with
a column names "mycol". the success value is a logical indicating success of the
call or not, additional optional outputs are not displayed in this example:

```matlabsession
>> [result, success] = mathworks.adx.run('print mycol="Hello World"')
result =
  table
        mycol    
    _____________
    "Hello World"
success =
  logical
   1
```

To get the contents of an entire table once can run the following command, here Parallel
processing of the resulting data has been enabled (if available), with a threshold
of 10000 rows of data. For more details on optimization see: [Performance.md](Performance.md).

```matlabsession
[result, success] = mathworks.adx.run('table("tableName", "all")', , useParallel=true, parallelThreshold=10000)
```

#### `KQLQuery` command

At a lower-level the above run command in this case calls the `KQLQuery` reference
implementation, here we also display the `requestId` which can be used for corelation:

```matlabsession
>> [result, success, requestId] = mathworks.adx.KQLQuery('print mycol="Hello World"')

result =
  table
        mycol    
    _____________
    "Hello World"

success =
  logical
   1

requestId = 
    "4faa0b41-e308-4436-a113-376aa20da525"
```

#### REST interface

At a still lower-level one can work with the REST interface more directly.
A `adx.data.models.QueryRequest` request object is first created. The `.db` property
is configured with the database name of interest. If not provided a default, if set,
will be read from the configuration file. The query itself `print Test="Hello World"`
is assigned to the `.csl` property. In this case no request properties are assigned
to the `propertiesProp` property. This will be used in a later example.

```matlabsession
% build a request object
req = adx.data.models.Query
Request;
req.db = "mydatabasename";
req.csl = 'print Test="Hello World"'
req = 
QueryRequest with properties:

             csl: "print mycol="Hello World""
              db: "mydatabasename"
  propertiesProp: []
```

The ADX cluster is assigned and with it a default scope. A default cluster and scope
can be set in the configuration to avoid setting them for exact query and or having
the values appear in source code. The ADX configuration may require that multiple
scopes would be set.

```matlabsession
% Configure a cluster and scope, defaults to be read from configuration files in future
cluster = "https://myclustername.myregion.kusto.windows.net";
scopes = ["https://myclustername.myregion.kusto.windows.net/.default"];
```

Now a `adx.data.api.Query` query object is created using the scope(s).

```matlabsession
% Create a query object
query = adx.data.api.Query('scopes', scopes);
query = 
Query with properties:

            serverUri: [0×0 matlab.net.URI]
          httpOptions: [1×1 matlab.net.http.HTTPOptions]
  preferredAuthMethod: [0×0 string]
          bearerToken: '<unset>'
               apiKey: '<unset>'
      httpCredentials: '<unset>'
           apiVersion: "2022-11-11"
       subscriptionId: '<redacted>'
             tenantId: '<redacted>'
         clientSecret: '<redacted>'
             clientId: '<redacted>'
               scopes: "https://myclustername.myregion.kusto.windows.net/.default"
              cookies: [1×1 adx.CookieJar]

```

Having configured the query object it can now be run the request that was previously
created on a given cluster, if a default is not used:

```matlabsession
[code, result, response] = query.queryRun(req, cluster)

code = 
  StatusCode enumeration
    OK
result = 
  1×5 QueryV2ResponseRaw array with properties:

    FrameType
    Version
    IsProgressive
    TableId
    TableKind
    TableName
    Columns
    Rows
    HasErrors
    Cancelled
    OneApiErrors

response = 
  ResponseMessage with properties:

    StatusLine: 'HTTP/1.1 200 OK'
    StatusCode: OK
        Header: [1×11 matlab.net.http.HeaderField]
          Body: [1×1 matlab.net.http.MessageBody]
     Completed: 0
```

Assuming success the result is a number of *Frames* that describe and contain tabular data.
This data can be converted to native MATLAB tables for ease of use.
Three tables are returned 2 containing metadata and a 3rd containing the data of,
interest, it is named the `PrimaryResult`.

```matlabsession
tables = mathworks.internal.adx.queryV2Response2Tables(result)
tables =
  3×1 cell array
    {1×3  table}
    {1×1  table}
    {3×12 table}
>> tables{1}.Properties.Description
ans =
    '@ExtendedProperties'
>> tables{2}.Properties.Description
ans =
    'PrimaryResult'
>> tables{3}.Properties.Description
ans =
    'QueryCompletionInformation'
>> tables
```

Looking at the `PrimaryResult` shows the response to the query:

```matlabsession
>> tables{2}
ans =
  table
         mycol      
    _______________
    "Hello World"
```

Putting the commands together:

```matlab
% build a request object
request = adx.data.models.QueryRequest();
colName = "myOutput";
message = "Hello World";
% set the KQL query
request.csl = sprintf('print %s="%s"', colName, message);
% Don't set the database use the default in .json config file
% request.db = "myDatabaseName"
% No adx.data.models.ClientRequestProperties required
% request.requestProperties
% Create the Query object and run the request
query = adx.data.api.Query();
% The default cluster to use is configured using a .json configuration file
% Run the query:
[code, result, response] = query.queryRun(request); %#ok<ASGLU>
if code == matlab.net.http.StatusCode.OK
    % Convert the response to Tables
    hwTable = mathworks.internal.adx.queryV2Response2Tables(result);
    fprintf("Query (%s) result:\n", request.csl);
    disp(hwTable);
else
    error('Error running query: %s', request.csl);
end
```

### Configuring request properties, to use tSQL using the low-level interface

The higher-level interface `mathworks.adx.tSQLQuery` automatically configures
the required request property to enable tSQL. However, as an example of how properties
can be configured directly using the lower level the following example is illustrative.
Note the `KQLQuery` and `run` commands both accept properties as optional arguments.

If not using the KQL language syntax the the *T-SQL* syntax can be used to write
queries. This is accomplished the query property `query_language` to `sql`.

```matlab
request = adx.data.models.QueryRequest();
request.csl = query;
% Don't set the database use the default in .json config file
% request.db = "databaseName";

% Configure ClientRequestPropertiesOptions & then ClientRequestProperties
crpo = adx.data.models.ClientRequestPropertiesOptions;
crpo.query_language = "sql";
crp = adx.data.models.ClientRequestProperties();
crp.Options = crpo;
request.requestProperties = crp;

% Create the Query object and run the request
query = adx.data.api.Query();
[code, result, response] = query.queryRun(request);
```

A reference implementation shows how this can be more concisely used:

```matlab
% Run the SQL query 'SELECT top(10) * FROM mytable' to return the 1st 10 row of a table
[result, success, requestId, resultTables, dataSetHeader, dataSetCompletion] = mathworks.adx.tSQLQuery('SELECT top(10) * FROM mytable')
```

The additional return values can be used to indicate if the query failed:

```matlab
if dataSetCompletion.HasErrors || dataSetCompletion.Cancelled
    error("Query had errors or was cancelled");
end
```

### Count the rows in a table, using the lower level interfaces

A query to count the rows in a table using KQL syntax:

```matlab
req = adx.data.models.QueryRequest;
req.csl = "['mytable'] | count";

q = adx.data.api.Query();
[code, result, response] = q.queryRun(req); %#ok<ASGLU>
if code == matlab.net.http.StatusCode.OK
    [result, resultTables] = mathworks.internal.adx.queryV2Response2Tables(result);
    count = result.Count;
end
```

In more detail, this example is based on a table created from the `airlinesmall.csv`
data set that is included with matlab use `which('airlinesmall.csv')` to get its
location. The result returned should be: 123523.

> Note that in early releases some warnings about unsupported data types and conversions may be expected.

```matlabsession
% Create a request
req = adx.ModelsDataPlane.QueryRequest;
req.db = "mydatabasename";
% The table name is: airlinesmallcsv;
% Kusto query string to count the rows in a given table
req.csl = "['airlinesmallcsv'] | count";

scopes = ["https://myclustername.myregion.kusto.windows.net/.default"];
cluster = "https://myclustername.myregion.kusto.windows.net";

q = adx.data.api.Query('scopes', scopes);
[code, result, response] = queryRun(q, req, cluster);

tables =
  3×1 cell array
    {1×3  table}
    {1×1  table}
    {3×12 table}
ans =
  table
    Count 
    ______
    123523
c =
  int64
   123523
ans =
    'int64'
```

### Progressive query execution

To execute a query in progressive mode the query request option property `results_progressive_enabled`
should be set to true.

```matlab
query = "['tableName '] | take " + 100;
args = {"database", database "propertyNames", "results_progressive_enabled", "propertyValues", {true}, "verbose", false};
[result, success, requestId, resultTables, dataSetHeader, dataSetCompletion] = mathworks.adx.KQLQuery(query, args{:});
```

### Get a list of tables

Get a list of tables and table properties:

```matlab
req = adx.data.models.QueryRequest('db', 'mydatabase', 'csl', '.show tables details');
[code, result, response] = q.queryRun(req);
```

Or more concisely:

```matlab
tableList = mathworks.adx.listTables(database="mydatabase")
```

### Export data to a local parquet file

The following example code exports an entire table to a known blob using
a Shared Access Signature blob URL. The resulting parquet file can be read
into a MATLAB table using `parquetread`. Parquet is recommended over CSV and
other formats for speed and data integrity reasons.

```matlab
exportURL = "https://myaccount.blob.core.windows.net/<REDACTED>";
exportURI = matlab.net.URI(exportURL);
SAS = exportURI.EncodedQuery;
query = "table('mytableName', 'all')";
[tf, result] = mathworks.adx.exportToBlob(exportURI.EncodedURI, query);
if ~tf
    error("exportToBlob failed");
end

downloadURL = result.Path(1) + "?" + SAS;
downloadURI = matlab.net.URI(downloadURL);
localFile = websave("exportedTable.gz.parquet", downloadURI);
T = parquetread(localFile);
```

### Ingest a table from a local a table

To ingest large volumes of data from MATLAB then the `ingestFile` and `ingestTable`
functions can be used:

```matlab
% Read some sample data from a parquet file to create a MATLAB table
inputTable = parquetread(parquetFile);
% Ingest the table into a given table
[success, result] =  mathworks.adx.ingestTable(inputTable, tableName=tableName);
```

To ingest small amounts of data from a MATLAB variable, typically a table the
`ingestInline`. This function is not suitable for bulk data or high performance
requirements.

```matlab
localPath = fullfile(matlabroot, "toolbox", "matlab", "demos", "outages.parquet");
tableName = "outages";
praquetTable = parquetread(localPath);
ingestData = praquetTable(1,:);

[success, result, requestId, extentId] = mathworks.adx.ingestInline(tableName, ingestData)

success =
  logical
   1
result =
  1x5 table
                   ExtentId                                    ItemLoaded                      Duration    HasErrors                 OperationId              
    ______________________________________    _____________________________________________    ________    _________    ______________________________________
    "8de6b799-6e12-4994-b57b-ed75e15db0a8"    "inproc:a607e293-dbdd-4f79-a1a2-a61982585adf"    00:00:00      false      "cd4184ca-0d31-4c42-a273-5f2953f76ddf"
requestId = 
    "63bb1cea-b589-45ac-82ad-00d68ca96aeb"
extentId = 
    "8de6b799-6e12-4994-b57b-ed75e15db0a8"
```

To ingest from another source in ADX itself rather than MATLAB see `ingestFromQuery`.

### Higher-level data handling functions

The following higher-level functions are provided to assist in common operations when working with data.
Use `doc mathworks.adx.<function-name>` for more details.

* createTable - Creates a table in a given database
* dropTable - Drops a table from a given database
* exportToBlob - Exports data to an Azure blob
* ingestFile - Ingests a local file to Azure Data Explorer using Azure blob
* ingestFileQueue - Ingests a local file to Azure Data Explorer using Azure blob & queue *(work in progress, do not use)*
* ingestTable - Ingests a MATLAB table to an Azure Data Explorer Table
* ingestTableQueue - Ingests a MATLAB table to an Azure Data Explorer Table *(work in progress, do not use)*
* ingestInline - Ingests limited amounts of data into Kusto directly from MATLAB
* ingestFromQuery - Ingest data using the result of a command or query
* listTables - Returns a list of tables and their properties
* tableExists - Returns true is a given table exists

## Control queries

### List Clusters

Start by creating a `Clusters` object:

```matlabsession
>> clusters = adx.Api.Clusters
clusters = 
  Clusters with properties:

              serverUri: [0×0 matlab.net.URI]
            httpOptions: [1×1 matlab.net.http.HTTPOptions]
    preferredAuthMethod: [0×0 string]
            bearerToken: '<unset>'
                 apiKey: '<unset>'
        httpCredentials: '<unset>'
             apiVersion: "2022-11-11"
         subscriptionId: '<redacted>'
               tenantId: '<redacted>'
           clientSecret: '<redacted>'
               clientId: '<redacted>'
                cookies: [1×1 adx.CookieJar]
```

Call the `clustersList` method:

```matlabsession
>> [code, result, response] = clusters.clustersList
code = 
  StatusCode enumeration
    OK
result = 
  ClusterListResult with properties:

    value: [1×1 adx.Models.Cluster]
response = 
  ResponseMessage with properties:

    StatusLine: 'HTTP/1.1 200 OK'
    StatusCode: OK
        Header: [1×13 matlab.net.http.HeaderField]
          Body: [1×1 matlab.net.http.MessageBody]
     Completed: 0

```

Examine the result, in this case there is one cluster:

```matlabsession
>> result.value
ans = 
  Cluster with properties:

            sku: [1×1 adx.Models.AzureSku]
     systemData: [0×0 adx.Models.systemData]
          zones: "1"
       identity: [1×1 adx.Models.Identity]
    xproperties: [1×1 adx.Models.ClusterProperties_1]
           etag: ""2023-01-04T12:40:35.3452388Z""
             id: "/subscriptions/06<REDACTED>74/resourceGroups/mbadx/providers/Microsoft.Kusto/Clusters/myclustername"
           name: "myclustername"
           type: "Microsoft.Kusto/Clusters"

>> result.value.sku
ans = 
  AzureSku with properties:

        name: Dev_No_SLA_Standard_E2a_v4
    capacity: 1
        tier: Basic
```

> The `[tf, cluster] = mathworks.adx.isClusterRunning(...)` command is a convenient function to
> easily determine if a default or given cluster is running or not.

### Management

```matlab
% Get Identity token
m = adx.data.api.Management('scopes', dataPlaneScopes)
req = adx.data.models.ManagementRequest 
req.csl = '.get kusto identity token'
ingestCluster = "https://ingest-myadxcluster.westeurope.kusto.windows.net"
[code, result, response] = m.managementRun(req, ingestCluster)

q = adx.data.api.Ingest()
```

More concisely using configured defaults:

```matlab
m = adx.data.api.Management()
req = adx.data.models.ManagementRequest
req.csl = '.get kusto identity token'
[code, result, response] = m.managementRun(req)
```

## References

For more sample commands see:

* Example code: `Software/MATLAB/adxDemo.m`
* Basic test code: `Software/MATLAB/test/unit/*.m`

For further API reference information see:

* [https://learn.microsoft.com/en-us/azure/data-explorer/kusto/management/access-control/how-to-authenticate-with-aad](https://learn.microsoft.com/en-us/azure/data-explorer/kusto/management/access-control/how-to-authenticate-with-aad)
* [https://learn.microsoft.com/en-us/azure/data-explorer/kusto/api/rest/](https://learn.microsoft.com/en-us/azure/data-explorer/kusto/api/rest/)
* [https://learn.microsoft.com/en-us/rest/api/azurerekusto/](https://learn.microsoft.com/en-us/rest/api/azurerekusto/)
* [https://learn.microsoft.com/en-us/azure/data-explorer/kusto/api/connection-strings/kusto](https://learn.microsoft.com/en-us/azure/data-explorer/kusto/api/connection-strings/kusto)
* [https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/sql-cheat-sheet](https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/sql-cheat-sheet)

[//]: #  (Copyright 2022-2024 The MathWorks, Inc.)
