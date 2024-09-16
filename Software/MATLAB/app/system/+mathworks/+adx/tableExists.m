function tf = tableExists(table, options)
    % TABLEEXISTS Returns true is a given table exists
    %
    % Example:
    %   tableExists = mathworks.adx.tableExists(tableName, database=database, cluster=cluster);
   
    % Copyright 2023-2024 The MathWorks, Inc.

    arguments
        table string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.database string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    args = mathworks.utils.addArgs(options, ["database", "cluster"]);
    tablesFound = mathworks.adx.listTables(args{:});

    tf = any(matches(tablesFound, table));
end

