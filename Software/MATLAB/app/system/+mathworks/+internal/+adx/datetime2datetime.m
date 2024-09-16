function literal = datetime2datetime(value)
    % datetime2datetime Converts a scalar MATLAB datetime to a Kusto datetime
    % A scalar or empty input value must be provided.
    %
    % See also: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/scalar-data-types/datetime

    % Copyright 2024 The MathWorks, Inc.

    arguments
        value datetime
    end

    if isempty(value)
        literal = "datetime(null)";
    else
        if ~isscalar(value)
            error("adx:datetime2datetime", "Expected a scalar or empty value");
        end
        if isnat(value)
            literal = "datetime(null)";
        else
            value.Format = 'yyyy-MM-dd''T''HH:mm:ss.SSS';
            literal = "datetime(" + string(value) +")";
        end
    end
end