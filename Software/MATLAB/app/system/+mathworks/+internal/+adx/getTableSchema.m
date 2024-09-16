function [result, success, requestId] = getTableSchema(tableName, options)
    % getTableSchema
    %
    % See also: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/management/show-table-schema-command

    % Copyright 2024 The MathWorks, Inc.

    arguments
        tableName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.JSONFormat (1,1) logical = false
        options.database string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.propertyNames (1,:) string {mustBeNonzeroLengthText}
        options.propertyValues (1,:) cell
        options.scopes string
        options.convertDynamics (1,1) logical = true
        options.nullPolicy (1,1) mathworks.adx.NullPolicy = mathworks.adx.NullPolicy.ErrorLogicalInt32Int64
        options.allowNullStrings (1,1) logical = true
        options.verbose (1,1) logical = false
    end

    if options.JSONFormat
        command = ".show table " + tableName + " schema as json";
    else
        command = ".show table " + tableName + " cslschema";
    end
    
    args = mathworks.utils.addArgs(options, ["database", "cluster", "propertyNames", "propertyValues", "scopes", "convertDynamics", "nullPolicy", "allowNullStrings", "verbose"]);

    [cmdResult, cmdSuccess, requestId] = mathworks.adx.mgtCommand(command, args{:});

    if ~cmdSuccess
        result = "";
        success = false;
    else
        if height(cmdResult) > 0 && numel(cmdResult.Properties.VariableNames) >1 && strcmp(cmdResult.Properties.VariableNames{2}, 'Schema')
            result = string(cmdResult{1,"Schema"});
            success = true;
        else
            result = "";
            success = false;
        end
    end
end