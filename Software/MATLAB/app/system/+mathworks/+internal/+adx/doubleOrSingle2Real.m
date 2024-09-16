function literal = doubleOrSingle2Real(value)
    % doubleOrSingle2Real Converts a MATLAB double or single to a Kusto real
    % A string is returned.
    % If empty real(null) is returned.
    % If nan real(nan) is returned.
    % If +inf real(+inf) is returned.
    % If -inf real(-inf) is returned.
    % A scalar or empty input value must be provided.
    %
    % See also: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/scalar-data-types/real

    % Copyright 2024 The MathWorks, Inc.

    arguments
        value
    end
    

    if isempty(value)
        literal = "real(null)";
    else
        if ~isscalar(value)
            error("adx:doubleOrSingle2Real", "Expected a scalar or empty value");
        end
        if isnan(value)
            literal = "real(nan)";
        elseif isinf(value)
            if value > 0
                literal = "real(+inf)";
            else
                literal = "real(-inf)";
            end
        else
            literal = string(value);
        end
    end
end