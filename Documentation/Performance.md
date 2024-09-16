# Performance

This package uses the [GSON](https://github.com/google/gson) Java library for
comprehensive JSON parsing, however this can have a performance impact when working
with queries that return large responses. If response times are slow and bandwidth
is not the issue the following should be considered:

* In general only KQL queries should return sufficient volumes of data to exhibit
query times that dominate the inherent communication time.

* Return the minimum amount of data.

* Where convenient to do so structure queries to perform data formatting and
filtering on the server side. This takes advantage of the proximity to the data
and the scale of the Azure Data Explorer platform.

* Ingesting from files or tables uses binary transfers, typically with optimized
binary parquet files, for larger volumes of data this is far more efficient than
repeated inline ingestion of small amounts of data.

* Simple JSON responses may be parsed faster using a custom row decoder, see below
for more details.

* Return int32s rather than int64s if precision is not a limitation.

* Avoid supporting nulls data if data is know to not have null values. See:
[NullData](NullData.md) for more details.

* The MATLAB [profiler](https://mathworks.com/help/matlab/matlab_prog/profiling-for-improving-performance.html)
can be a good way to visualize what portions of query processing are consuming most time.

* If responses contain [dynamic](Dynamics.md) fields where not all values returned
may be used consider decoding them at the time of use as needed rather than as
part of the query.

* If getting direct access to the raw data return in response is required, this
can be accomplished using the lower-level functions.

## Parallel Processing

If Parallel Computing Toolbox is installed (use `ver` to check), then it can be
used to speed up the processing of KQL query rows. Use the optional `useParallel`
argument to enable this (default is `false`). Additionally a threshold of rows
can be applied below which Parallel processing will not be used. The default is 1000.
The best value for this threshold will depend on the content of the rows and whether
repeated large row count calls are made, some experimentation may be required.
This can also be used with custom row decoders. The default row decoder requires
a process based parpool.

Here a parallel processing is enabled along with a custom row decoder, parallelism is applied for
queries returning 10000 rows or more.

Example:

```matlab
h = @mathworks.internal.adx.exampleCustomRowDecoder;
[result, success] = mathworks.adx.run(query, useParallel=true, parallelThreshold=10000, customRowDecoder=h);
```

## Custom row decoder

If queries result in a simple JSON response then writing a custom decoder to
extract the required data rather than using the default decoder.

A sample of such a decoder `/Software/MATLAB/app/system/+mathworks/+internal/+adx/exampleCustomRowDecoder.m`
is provided. This function handles an array of rows of the form: `[128030544,1.0,"myStringValue-1"]`
with fields of types int64, double and a string.

It will not process other data and is intended for speed rather than strict correctness or robustness.

The custom decoder is applied to the PrimaryResult rows field only.

It is required to return a cell array of size number of rows by the number of
columns that can be converted to a MATLAB table with the given schema.

It is not required to respect input arguments flags if foreknowledge of returned
data permits it.

Custom row decoders can be applied to progressive and nonprogressive KQL API v2
and KQL API v1 mode queries.

When a custom decoder is not used the generic decoder `mathworks.internal.adxgetRowsWithSchema`
is used.

A [function handle](https://mathworks.com/help/matlab/matlab_prog/creating-a-function-handle.html)
is used to pass a handle to the custom row decoder to the `run` or `KQLquery` commands.

Example:

```matlab
query = sprintf('table("%s", "all")', tableName);
crd = @mathworks.internal.adx.exampleCustomRowDecoder;
[result, success] = mathworks.adx.run(query, customRowDecoder=crd);
```

The `exampleCustomRowDecoder` example implements a Parallel Computing based `parfor`
based parallelization, this is not required but may be helpful.

> Depending on the nature of the decoder code a process based pool may be required
> rather than a thread based pool.
> It is unlikely that a decoding process would benefit from a remote processing via
> a cluster based pool but this would be possible.

## doNotParse parallel array processing (Experimental)

A JSON array of `doNotParse` values being processed by `JSONMapper` must be checked
for paired double quotes added to some value types the gson `toString` method.
While trivial this can be slow if there are many elements for example, row values.

An experimental flag (`useParallel`) can be set to true to enable parallel
processing of this step using `parfor` if Parallel Computing Toolbox is available.
The property can be set in: `/Software/MATLAB/app/system/+adx/+control/JSONMapper.m`
in the `fromJSON` method.

## Skip parsing row array elements (skipRowsArrayDecode)

>The following applies to v2 queries only.

While the Rows array elements are not parsed by the the generation of a `adx.data.models.QueryV2ResponseRaw`
in a `adx.data.api.Query.queryRun` call prior to the generation of a MATLAB table,
as done by the higher-level `mathworks.adx.KQLQuery` function, the array
itself is parsed.

If the optional named argument `skipRowsArrayDecode` is used with a `adx.data.api.Query.queryRun`
call then the frames are parsed but the Rows array itself is not. This enables
If parsing the Rows independently if needed in a performance optimal way.

Example:

```matlab
% Create a request
request = adx.data.models.QueryRequest();
request.csl = "mytablename | take  100";

% Create the Query object and run the request
query = adx.data.api.Query();
[code, result, response, id] = query.queryRun(request, apiVersion="v2", skipRowsArrayDecode=true);
```

[//]: #  (Copyright 2024 The MathWorks, Inc.)
