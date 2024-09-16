function literal = charOrString2Guid(value)
    % charOrString2Guid Converts a scalar MATLAB string or char to a Kusto guid
    % Example: guid(74be27de-1e4e-49d9-b579-fe0b331d3642)
    % A scalar or empty input value must be provided.
    % If an empty value is provided guid(null) is returned.
    %
    % See also: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/scalar-data-types/guid

    % Copyright 2024 The MathWorks, Inc.

    arguments
        value string
    end

    if isempty(value)
        literal = "guid(null)";
    else
        if ~isStringScalar(value)
            error("adx:charOrString2Guid", "Expected a scalar or empty value");
        end
        literal = "guid(" + value + ")";
    end
end