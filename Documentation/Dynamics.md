# Dynamic Data

The Azure Data Explorer® Documentations describes the dynamic data type as follows:

The dynamic scalar data type is special in that it can take on any value of other
scalar data types from the list below, as well as arrays and property bags.
Specifically, a dynamic value can be:

    * Null.
    * A value of any of the primitive scalar data types: bool, datetime, guid, int, long, real, string, and timespan.
    * An array of dynamic values, holding zero or more values with zero-based indexing.
    * A property bag that maps unique string values to dynamic values. The property bag has zero or more such mappings (called "slots"), indexed by the unique string values. The slots are unordered.

For further details see: [https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/scalar-data-types/dynamic](https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/scalar-data-types/dynamic)

When ADX returns dynamic data to MATLAB® the potentially varied nature of that data
means that such a column in a results table will be of type cell.
For reasons that will be described it may be preferred to not attempt convert the
dynamic data to an underlying type(s) but rather to simply return the value
of the the dynamic as a character vector. The optional argument `convertDynamics`
can be used to control this behavior, the default value is true, i.e. attempt to
convert the dynamic data.

If automatic decoding of a value does not give the desired result it is recommended
that the values not be decoded and custom logic be implemented to do so using the
returned character vector values.

If a dynamic is *not* to be converted the following approach is taken.

* If the value is presents as a JSON array or object, the character vector value
is returned.
* If the value is a JSON null, the `NullPolicy` is applied, by default a `missing`
will be returned.
* Otherwise the character vector value is returned.

If the dynamic value is to be converted this cannot be handled with the same certainty
as the conversion of other data types. The metadata returned from ADX does not
describe the contents of the value or provide a schema that might be used to decode
it. ADX does not have such information. Thus the automatic decoding should be
considered a best effort. When decoding dynamics the following steps are taken in
sequence:

* If the value is a JSON primitive, Booleans will be converted to logicals and numbers
will be converted to doubles. Null policy is applied. Strings will be passed to MATLAB's `jsondecode`
function. If the `jsondecode` call fails the value will be returned as a character vector.
* If the value is a JSON null `NullPolicy` is applied and by default a `missing`
is returned.
* If the value is an empty JSON array `NullPolicy` is applied and by default a missing
is returned. Non empty JSON arrays are decoded using `jsondecode`, if that fails
the character vector value is returned.
* If the value is a JSON object is decoded using decoded using `jsondecode`, if that fails
the character vector value is returned.

*Note:*

* For more information on MATLAB's `jsondecode` function see:
[https://www.mathworks.com/help/matlab/ref/jsondecode.html](https://www.mathworks.com/help/matlab/ref/jsondecode.html) noting that it has limitations
* For further details on the handling of null values see [NullData.md](NullData.md).
* The additional processing of dynamic values as described inevitably has a performance
impact, if this is a concern consider approaches that alter the data being queried
or queries themselves such that non dynamic data types are used.

The `testDynamic` test function in `/matlab-azure-adx/Software/MATLAB/test/unit/testDataTypes.m`
shows some simple queries that used for dynamic testing purposes.

[//]: #  (Copyright 2024 The MathWorks, Inc.)
