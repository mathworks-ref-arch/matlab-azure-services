function [tableNames, success, tableDetails] = listTables(options)
    % listTables Returns a list of tables and their properties
    % 
    % contains the specified table or all tables in the
    % database with a detailed summary of each table's properties.
    % You must have at least Database User, Database Viewer, or Database
    % Monitor permissions to run this command.
    % 
    % Optional arguments
    %  database: Database name string, the default is taken from the JSON settings file.
    %
    %  cluster: Cluster name string, the default is taken from the JSON settings file.
    %
    % Returns
    %  tableNames: A string array of the table names.
    %
    %  Success: Logical true if the query successfully completes, otherwise false.
    %
    %  tableDetails: A table containing metadata about the tables. 

    % Copyright 2023-2024 The MathWorks, Inc.

    arguments
        options.database string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical
    end

    args = mathworks.utils.addArgs(options, ["bearerToken", "cluster", "verbose"]);

    query = '.show tables details';

    [tableDetails, success] = mathworks.adx.run(query, args{:});

    if success
        tableNames = tableDetails.TableName';
    else
        tableNames = string.empty;
        tableDetails = table.empty;
    end
end
