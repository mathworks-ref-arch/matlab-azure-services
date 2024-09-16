function result = dropTable(tableName, options)
    % dropTable Drops a table from a given database
    %
    % The .drop table command only soft deletes the data.
    % Data can't be queried, but is still recoverable from persistent storage.
    % The underlying storage artifacts are hard-deleted according to the
    % recoverability property in the retention policy that was in effect at
    % the time the data was ingested into the table.
    %
    % Require argument:
    %     tableName : The name of the table to drop. Type string.
    %
    % Optional arguments:
    %      ifExists : If specified and if true the command won't fail if the table
    %                 doesn't exist. Type logical.
    %      database : Non default database name. Type string.
    %       cluster : Non default cluster name. Type string.
    %   bearerToken : Non default token value. Type string.
    %
    % Returns a table of remaining tables and some properties or an
    % adx.control.models.ErrorResponse.
    %
    % Example:
    %
    %     result = mathworks.adx.dropTable("TestTable")
    % result =
    %   5×4 table
    %         TableName        DatabaseName     Folder      DocString
    %     _________________    ____________    _________    _________
    %     "airlinesmall"        "testdb1"      <missing>    <missing>
    %     "airlinesmallcsv"     "testdb1"      <missing>    <missing>
    %     "itable"              "testdb1"      <missing>    <missing>
    %     "myparquet"           "testdb1"      <missing>    <missing>
    %     "outagesTable"        "testdb1"      <missing>    <missing>
    %
    % See also: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/management/drop-table-command

    % Copyright 2023 The MathWorks, Inc.

    arguments
        tableName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.ifExists logical
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

    cmdString = ".drop table " + tableName;

    if isfield(options, 'ifExists')
        if options.ifExists
            cmdString = cmdString + " ifexists";
        end
    end

    req = adx.data.models.ManagementRequest('db' ,database, 'csl', cmdString);

    [code, runResult, response] = managementClient.managementRun(req); %#ok<*ASGLU>

    if code == matlab.net.http.StatusCode.OK
        if isa(runResult, 'adx.data.models.QueryV1ResponseRaw')
            if nargout > 0
                result = mathworks.internal.adx.queryV1Response2Tables(runResult, allowNullStrings=true);
                if ~istable(result)
                    warning("adx:dropTable", "Unexpected nontabluar result returned");
                end
            end
        elseif isa(runResult, 'adx.control.models.ErrorResponse')
            if options.verbose; fprintf("dropTable failed for: %s\n", tableName); end
            result = runResult;
        else
            error("adx:dropTable", "Unexpected return type: %s", class(runResult));
        end
    else
        if isa(runResult, 'adx.control.models.ErrorResponse')
            if options.verbose; fprintf("dropTable failed for: %s\n", tableName); end
            result = runResult;
        else
            error("adx:dropTable", "Unexpected return type: %s", class(runResult));
        end
    end
end