function bool = logical2Bool(value)
    % logical2Bool Converts a MATLAB logical to a Kusto bool
    % A string is returned.
    % If empty bool(null) is returned, otherwise bool(true)
    % or bool false.
    % A scalar or empty input value must be provided.

    % Copyright 2024 The MathWorks, Inc.

    arguments
        value logical
    end
    
    if isempty(value)
        bool = "bool(null)";
    else
        if ~isscalar(value)
            error("adx:logical2Bool", "Expected a scalar or empty value");
        end
        if value
            bool = "bool(true)";
        else
            bool = "bool(false)";
        end
    end
end