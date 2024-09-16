function [tf, result] = createTable(matlabTable, tableName, options)
    % createTable Creates a table in a given database
    % The contents of the table are not ingested, only the schema
    %
    % Require arguments:
    %   matlabTable : The matlabTable to base Kusto table upon. Type table.
    %                 The table need not have content only columns of the
    %                 correct types.
    %     tableName : The name of the table to create. Type string.
    %
    % Optional arguments:
    %  tableProperties : Key value properties for the table, Type containers.Map.
    %         database : Non default database name. Type string.
    %          cluster : Non default cluster name. Type string.
    %      bearerToken : Non default token value. Type string.
    %
    % Returns a logical true and a table describing the created table or a
    % logical false and a adx.control.models.ErrorResponse or an empty MATLAB Table.
    %
    % Example:
    %
    %   % Create a sample table T
    %   LastName = ["Sanchez";"Johnson";"Li"];
    %   Age = [int32(38); int32(43); int32(38)];
    %   Height = [int64(71); int64(69); int64(64)];
    %   Weight = [176; 163; 131];
    %   T = table(LastName,Age,Height,Weight);
    %   [tf, result] = mathworks.adx.createTable(T, "health")
    %
    %   tf =
    %    logical
    %     1
    %   result =
    %     1x5 table
    %
    %   TableName                                                                                                                                       Schema                                                                                                                                       DatabaseName     Folder      DocString
    %   _________    ____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________    ____________    _________    _________
    %   "health"     "{"Name":"health","OrderedColumns":[{"Name":"LastName","Type":"System.String","CslType":"string"},{"Name":"Age","Type":"System.Int32","CslType":"int"},{"Name":"Height","Type":"System.Int64","CslType":"long"},{"Name":"Weight","Type":"System.Double","CslType":"real"}]}"     "testdb1"      <missing>    <missing>
    %
    % See also: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/management/create-table-command

    % TODO generate adx.control.models.ErrorResponse rather than return empty MATLAB tables

    % Copyright 2023-2024 The MathWorks, Inc.

    arguments
        matlabTable table {mustBeNonempty}
        tableName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.tableProperties containers.Map
        options.database string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.bearerToken string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = false
    end

    args = mathworks.utils.addArgs(options, ["bearerToken", "cluster"]);
    managementClient = adx.data.api.Management(args{:});

    if isfield(options, 'database')
        database = options.database;
    else
        database = managementClient.database;
    end

    % If the table exists just return
    if mathworks.adx.tableExists(tableName, database=database, cluster=managementClient.cluster)
        fprintf("Not creating table, table: %s already exists in database: %s\n", tableName, database);
        tf = false;
        result = table.empty;
        return;
    end

    % Don't rely on automatic string conversion for now
    if ~validateColumnTypes(matlabTable)
        fprintf("Not creating table, datatype conversion not possible\n");
        tf = false;
        result = table.empty;
        return;
    end

    mapStr = createTableMapping(matlabTable);

    cmdString = ".create table " + tableName + "(" + mapStr + ")";

    if isfield(options, 'tableProperties')
        if length(options.tableProperties) > 0 %#ok<ISMT>
            cmKeys = keys(options.tableProperties);
            cmValues = values(options.tableProperties);
            cmdString = cmdString + " with(";
            for n = 1:length(options.tableProperties)
                cmdString = cmdString + cmKeys{n} + "=" + cmValues{n};
                if n < length(options.tableProperties)
                    cmdString = cmdString + ", ";
                end
            end
            cmdString = cmdString + ")";
        end
    end

    req = adx.data.models.ManagementRequest('db', database, 'csl', cmdString);

    [code, runResult, response] = managementClient.managementRun(req); %#ok<*ASGLU>

    tf = false; %#ok<NASGU> % assume failure
    if code == matlab.net.http.StatusCode.OK
        if isa(runResult, 'adx.data.models.QueryV1ResponseRaw')
            result = mathworks.internal.adx.queryV1Response2Tables(runResult, allowNullStrings=true);
            if ~istable(result)
                fprintf("Unexpected non-tabular result returned for database: %s, table: %s, command:\n%s\n\n", database, tableName, cmdString);
                tf = false; % Something is probably wrong, fail
            else
                tf = true;
            end
        elseif isa(runResult, 'adx.control.models.ErrorResponse')
            if options.verbose; fprintf("createTable failed for database: %s, table: %s, command:\n%s\n\n", database, tableName, cmdString); end
            result = runResult; 
            tf = false;
        else
            error("adx:createTable", "Unexpected return type: %s", class(runResult));
        end
    else
        if isa(runResult, 'adx.control.models.ErrorResponse')
            if options.verbose; fprintf("createTable failed for database: %s, table: %s, command:\n%s\n\n", database, tableName, cmdString); end
            result = runResult;
            tf = false;
        else
            error("adx:createTable", "Unexpected return type: %s", class(runResult));
        end
    end
end


function tf = validateColumnTypes(T)
    % validateColumnTypes Returns true if all datatype can be handled

    arguments
        T table {mustBeNonempty}
    end

    mNames = T.Properties.VariableNames;
    mTypes = varfun(@class,T,'OutputFormat','cell');

    supportedTypes = ["int32", "int64", "string", "double", "datetime", "duration", "logical"];

    tf = true;
    for n = 1:numel(mTypes)
        if ~any(contains(supportedTypes, mTypes{n}))
            fprintf("Table column: %s is of type: %s, this is not a support type for conversion\n", mNames{n}, mTypes{n});
        end
    end
end


function mapStr = createTableMapping(T)
    % createTableMapping create table name and type string
    % Form:
    % Region:string, OutageTime:datetime, Loss:double, Customers:double, RestorationTime:datetime, Cause:string

    arguments
        T table {mustBeNonempty}
    end

    mNames = T.Properties.VariableNames;
    mTypes = varfun(@class,T,'OutputFormat','cell');

    mapStr = "";
    for n = 1:numel(mTypes)
        kType = string(mathworks.internal.adx.mapTypesMATLABToKusto(mTypes{n}));
        mapStr = mapStr + string(mNames{n}) + ":" + kType;
        if n < numel(mTypes)
            mapStr = mapStr + ", ";
        end
    end
end