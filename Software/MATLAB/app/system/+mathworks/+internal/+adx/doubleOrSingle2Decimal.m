function literal = doubleOrSingle2Decimal(value)
    % doubleOrSingle2Decimal Converts a MATLAB double or single to a Kusto decimal
    % A string is returned.
    % If empty decimal(null) is returned.
    % Otherwise decimal(<value>) is returned.
    % A scalar or empty input value must be provided.
    %
    % Note Arithmetic operations involving decimal values are significantly slower
    % than operations on real data type. As MATLAB does not support floating point
    % precision beyond double using doubleOrSingle2Real() instead is recommended
    % if a real value can be used.
    %
    % See also: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/scalar-data-types/decimal

    % Copyright 2024 The MathWorks, Inc.

    arguments
        value
    end
    
    if isempty(value)
        literal = "decimal(null)";
    else
        if ~isscalar(value)
            error("adx:doubleOrSingle2Decimal", "Expected a scalar or empty value");
        end
        literal = "decimal("+ string(value) ")";
    end
end