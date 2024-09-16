function literal = toKustoLiteral(value)
    % toKustoLiteral Converts a MATLAB value to a Kusto Literal
    % Supports duration, logical, int, double, single, string, char, and 
    % datetime MATLAB input types.
    %
    % See also: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/scalar-data-types

    % Copyright 2024 The MathWorks, Inc.

    switch(class(value))
        case "duration"
            literal = mathworks.internal.adx.duration2Timespan(value);

        case "logical"
            literal = mathworks.internal.adx.logical2Bool(value);

        case "int"
            literal = mathworks.internal.adx.int2IntOrLong(value);

        case {"double", "single"}
            literal = mathworks.internal.adx.doubleOrSingle2Real(value);

        case {"string", "char"}
            literal = mathworks.internal.adx.charOrString2String(value);

        case "datetime"
            literal = mathworks.internal.adx.datetime2datetime(value);
    
        otherwise
            error("adx:toKustoLiteral", "Unsupported value type: %s", class(value));
    end
end
