function literal = toDynamic(value)
    % toDynamic Creates a Kusto dynamic literal value
    %
    % See also: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/scalar-data-types/dynamic

    % Copyright 2024 The MathWorks, Inc.

    if isempty(value)
        literal = "dynamic(null)";
        return;
    end

    if isscalar(value) && numel(value)==1
        literal = "dynamic(" + mathworks.internal.adx.toKustoLiteral(value) ")";
        return
    end

    if iscell(value)
        if numel(value) == 0
            literal = "dynamic([])";
        else
            literal = "dynamic([";
            for n = 1:numel(value)
                literal = literal + mathworks.internal.adx.toKustoLiteral(value{n});
                if n < numel(value)
                    literal = literal + ",";
                end
            end
            literal = literal + "])";
        end
    end
end