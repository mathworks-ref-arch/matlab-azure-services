function outType = mapTypesKustoToMATLAB(inType)
    % MAPTYPESKUSTOTOMATLAB Map a Kusto scalar datatype name to a MATLAB type.
    %   OUTTYPE = MAPTYPESKUSTOTOMATLAB(INTYPE) returns the MATLAB type name
    %   corresponding to the Kusto scalar datatype name inType.
    %
    %   Input
    %   -----
    %   inType must be a nonempty text scalar and may be provided as a
    %   string scalar or character vector. Matching is case-insensitive.
    %
    %   Output
    %   ------
    %   outType is returned as a string scalar containing the MATLAB type
    %   name used by the ADX import layer.
    %
    %   Supported mappings
    %   ------------------
    %   Kusto type    MATLAB type
    %   ----------    -----------
    %   "int"         "int32"
    %   "long"        "int64"
    %   "string"      "string"
    %   "guid"        "string"
    %   "real"        "double"
    %   "datetime"    "datetime"
    %   "dynamic"     "cell"
    %   "bool"        "logical"
    %   "timespan"    "duration"
    %   "decimal"     "double"
    %
    %   Unsupported input values issue the warning:
    %   "adx:mapTypesKustoToMATLAB" and default to "string".
    %
    %   See: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/scalar-data-types/
    %   for Kusto scalar datatype definitions and .NET mapping guidance.

    % Copyright 2023-2026 The MathWorks, Inc.

    arguments (Input)
        inType string {mustBeNonzeroLengthText, mustBeTextScalar}
    end
    arguments (Output)
        outType string
    end

    switch lower(inType)
        case "int"
            outType = "int32";

        case "long"
            outType = "int64";

        case "string"
            outType = "string";

        case "guid"
            outType = "string";

        case "real"
            outType = "double";

        case "datetime"
            outType = "datetime";

        case "dynamic"  % Generally JSON
            outType = "cell";

        case "bool"
            outType = "logical";

        case "timespan"
            outType = "duration";

        case "decimal"
            outType = "double";

        otherwise
            warning("adx:mapTypesKustoToMATLAB","Unexpected type found: %s, defaulting to conversion to a string if possible", inType);
            outType = "string";
    end
end
