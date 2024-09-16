# Null data

In ADX all data types except string may have null values indicating that data is
not present. When bringing such data into MATLAB® consideration must be given to
the potential presence of null values. This package provides a number of approaches
to dealing with this issue.

Many MATLAB types support the concept of "missing" data where the `missing` *value*
can be used to identify data that is not available, see also `ismissing()`.
Other datatypes support `NaN` or `NaT` to indicate *anomalous* values.

The enumeration class `mathworks.adx.NullPolicy` can be passed as an
option to query functions to control how nulls are handled in responses. The
possible values of the enumeration are defined in the following table:

| Enumeration    | Effect     |
|:---------------|------------|
| ErrorAny       | Error if any null values are detected |
| ErrorLogicalInt32Int64 | Error if null values are detected for logicals, int32s or int64s |
| AllowAll       | All null types to map to missing, NaN or NaT for all data types |
| Convert2Double | Convert logicals, int32s, & int64s to doubles |

The default behavior is defined by `ErrorLogicalInt32Int64`.

Using the `AllowAll` policy has the effect of returning data as cell array values
This has an impact on memory and performance, for large queries altering the data
or the query to remove null may be preferable.

The following table defines how an ADX null is translated to a MATLAB value
subject to the enumeration value.
As dynamics can be converted into other types this table assumes the valid value
is not converted and thus remains a cell array containing a character vector.

| Kusto type | MATLAB type | ADX Value | ErrorAny    | ErrorLogicalInt32Int64 | AllowAll    | Convert2Double     |
|:-----------|:------------|:----------|:------------|:-----------------------|:------------|:-------------------|
| bool       | logical     | null      | error       | error                  | {missing}   | NaN                |
|            |             | valid     | logical     | logical                | {logical}   | 0 or 1 as a double |
| int        | int32       | null      | error       | error                  | {missing}   | NaN                |
|            |             | valid     | int32       | int32                  | {int32}     | as a double        |
| long       | int64       | null      | error       | error                  | {missing}   | NaN                |
|            |             | valid     | int64       | int64                  | {int64}     | as a double [N1]   |
| datetime   | datetime    | null [N5] | error       | NaT                    | NaT         | NaT                |
|            |             | valid     | datetime    | datetime               | datetime    | datetime           |
| guid       | string      | null      | error       | missing                | missing     | missing            |
|            |             | valid     | string      | string                 | string      | string             |
| real       | double      | null      | error       | NaN                    | NaN         | NaN                |
|            |             | valid     | double      | double                 | double      | double             |
| string     | string      | N/A [N3]  | error       | ""                     | ""          | ""                 |
|            |             | N/A [N4]  | ""          | ""                     | ""          | ""                 |
|            |             | valid     | string      | string                 | string      | string             |
| timespan   | duration    | null      | error       | NaN                    | NaN         | NaN                |
|            |             | valid     | duration    | duration               | duration    | duration           |
| decimal    | double      | null      | error       | NaN                    | NaN         | NaN                |
|            |             | valid     | double      | double                 | double      | double [N1]        |
| dynamic    | char [N2]   | null      | error       | {missing}              | {missing}   | {missing} [N2]     |
|            |             | valid     | {char} [N2] | {char} [N2]            | {char} [N2] | {char} [N2]        |

| Notes |      |
| ----- | ---- |
| [N1]  | Subject to loss of precision |
| [N2]  | Assuming the value is not decode, see [Dynamics.md](Dynamics.md) |
| [N3]  | Kusto does not store null strings, however metadata and commands can return null strings that still need to be converted to tables |
| [N4]  | If the allowNullStrings argument is set the the nullPolicy is not applied a warning is issued, this can be used to enable different behavior in queries and commands for example |
| [N5]  | When a datetime NaT is returned its timezone is set to UTC as per other datetimes |

> Note that metadata tables returned along side conventional query results also
> adopt the null policy applied to the query result.

The `testNulls` test function in `/matlab-azure-adx/Software/MATLAB/test/unit/testDataTypes.m`
shows some simple queries that can be used to easily return nulls for testing purposes.

## Null error

If a null is encountered, in this case a null long/int64 is returned when using a
null policy that does not support it an error such as the following is returned.
In this case a possible solution would be:
`mathworks.adx.run(myQueryString, mathworks.adx.NullPolicy.AllowAll)`
It may be preferable to resolve this issue in the query or the data set such that
the data returned to MATLAB is free of nulls.

```matlabsession
>> [result, success] = mathworks.adx.run(myQueryString)
Error using mathworks.internal.adx.getRowWithSchema>convert2Int64 (line 237)
int64 null values are not supported when using: mathworks.adx.NullPolicy.ErrorLogicalInt32Int64, consider using mathworks.adx.NullPolicy.AllowAll, (2,18)
Error in mathworks.internal.adx.getRowWithSchema (line 50)
                row{colIdx} = convert2Int64(curElement, nullPolicy, rowIdx, colIdx);
```

>Tip: In the above error message the `(2,18)` indicates that the issue was detected
>in row 2 column 18.

## References

* [https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/scalar-data-types/null-values](https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/scalar-data-types/null-values)

[//]: #  (Copyright 2024 The MathWorks, Inc.)
