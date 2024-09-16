function literal = int2IntOrLong(value)
    % int2IntOrLong Converts a MATLAB int to a Kusto int or long
    % A scalar or empty input value must be provided.
    % A scalar string is returned.
    % If empty an int(null) or long(null) is returned.
    %
    % See also:
    %   https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/scalar-data-types/int
    %   https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/scalar-data-types/long

    % Copyright 2024 The MathWorks, Inc.

    arguments
        value
    end
    
    switch(class(value))
        case {"int8", "int16", "int32"}
            if isempty(value)
                literal = "int(null)";
            else
                if ~isscalar(value)
                    error("adx:int2IntOrLong", "Expected a scalar or empty value");
                end
                literal = sprintf("int(%d)", value);
            end

        case {"uint8", "uint16", "uint32"}
            if isempty(value)
                literal = "int(null)";
            else
                if ~isscalar(value)
                    error("adx:int2IntOrLong", "Expected a scalar or empty value");
                end
                literal = sprintf("int(%u)", value);
            end

        case {"int64"}
            if isempty(value)
                literal = "long(null)";
            else
                if ~isscalar(value)
                    error("adx:int2IntOrLong", "Expected a scalar or empty value");
                end
                literal = sprintf("long(%d)", value);
            end
        
        otherwise
            error("adx:int2IntOrLong", "Unsupported value type: %s", class(value));
    end
end

