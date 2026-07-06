function outType = mapTypesMATLABToKusto(inType)
    % MAPTYPESMATLABTOKUSTO Map a MATLAB type name to a Kusto scalar datatype.
    %   outType = mapTypesMATLABToKusto(inType) returns the Kusto scalar
    %   datatype name corresponding to the MATLAB type name inType.
    %
    %   Input
    %   -----
    %   inType must be a nonempty text scalar and may be provided as a
    %   string scalar or character vector. Matching is case-insensitive.
    %
    %   Output
    %   ------
    %   outType is returned as a scalar string containing the Kusto scalar
    %   datatype name used when generating ADX schema definitions.
    %
    %   Supported mappings
    %   ------------------
    %   MATLAB type       Kusto type
    %   -----------       ----------
    %   "int32"           "int"
    %   "int8"            "int"
    %   "uint8"           "int"
    %   "int16"           "int"
    %   "uint16"          "int"
    %   "int64"           "long"
    %   "uint32"          "long"
    %   "string"          "string"
    %   "char"            "string"
    %   "double"          "real"
    %   "single"          "real"
    %   "datetime"        "datetime"
    %   "duration"        "timespan"
    %   "logical"         "bool"
    %
    %   Unsupported input values issue the warning:
    %   "adx:mapTypesMATLABToKusto:Unsupported" and default to "string".
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
        case {"int32", "int8", "uint8", "int16", "uint16"}
            outType = "int";

        case {"int64", "uint32"}
            outType = "long";

        case {"string", "char"}
            outType = "string";

        case {"double", "single"}
            outType = "real";

        case "datetime"
            outType = "datetime";

        case "duration"
            outType = "timespan";

        case "logical"
            outType = "bool";

        otherwise
            warning("adx:mapTypesMATLABToKusto:Unsupported","Unsupported type found: %s, defaulting to conversion to a string if possible", inType);
            outType = "string";
    end
end
