function [mTable, tableSchema, matlabSchema, kustoSchema] = getTableAndSchemas(columns, numRows, options)
    % getTableAndSchemas Returns a MATLAB table to store a returned Kusto table
    %
    % The table is not populated.
    % Column names are mapped to valid MATLAB column names using matlab.lang.makeValidName
    % Datatype schemas are also returned.
    % MATLAB types mapped from the Kusto types using mathworks.internal.adx.mapTypesKustoToMATLAB
    %
    % Required Arguments
    %  columns: 1d array of adx.data.models.Column
    %
    %  numRows: Number of rows in the table
    %
    % Optional Arguments
    %  name: Name for the table, the default is: "". matlab.lang.makeValidName is applied.
    %
    %  nullPolicy: A mathworks.adx.NullPolicy to determine how nulls are handled
    %              Default is mathworks.adx.NullPolicy.ErrorLogicalInt32Int64
    %
    %  verbose: Logical to enable additional output, default is false.
    %
    % Return Values:
    %  mTable: Unpopulated MATLAB table.
    %
    %  matlabSchema: String array of the underlying MATLAB types for columns which
    %                may be stored in a cell to enable representation of nulls
    %
    %  tableSchema: String array of the actual MATLAB column types used to create the table
    %
    %  kustoSchema: String array of the Kusto type fields for the columns also
    %               stored in the table descriptions fields

    % Copyright 2024 The MathWorks, Inc.

    arguments
        columns (1,:) % Should work with both adx.data.models.Column & adx.data.models.ColumnV1 as the V1 DataType field is not used
        numRows (1,1) int64
        options.name (1,1) string = ""
        options.nullPolicy (1,1) mathworks.adx.NullPolicy = mathworks.adx.NullPolicy.ErrorLogicalInt32Int64
        options.verbose (1,1) logical = false
    end

    if ~(isa(columns, 'adx.data.models.Column') || isa(columns, 'adx.data.models.ColumnV1'))
        error("adx:getTableAndSchemas","Expected columns to be of type adx.data.models.Column or adx.data.models.ColumnV1");
    end

    numCols = numel(columns);

    % Create cell arrays to store the table properties
    variableNames = cell(numCols, 1);
    variableTypes = cell(numCols, 1);
    matlabTypes = cell(numCols, 1);
    variableDescriptions = cell(numCols, 1);

    for m = 1:numCols
        variableNames{m} = char(matlab.lang.makeValidName(columns(m).ColumnName));
        matlabTypes{m} = mathworks.internal.adx.mapTypesKustoToMATLAB(columns(m).ColumnType);
        switch options.nullPolicy
            case mathworks.adx.NullPolicy.AllowAll
                switch lower(matlabTypes{m})
                    case {'int32', 'int64', 'logical'}
                        variableTypes{m} = 'cell';
                    otherwise
                        variableTypes{m} = matlabTypes{m};
                end
            case mathworks.adx.NullPolicy.Convert2Double
                switch lower(matlabTypes{m})
                    case {'int32', 'int64', 'logical'}
                        variableTypes{m} = 'double';
                    otherwise
                        variableTypes{m} = matlabTypes{m};
                end
            otherwise
                variableTypes{m} = matlabTypes{m};
        end
        variableDescriptions{m} = char(columns(m).ColumnType);
    end

    % Create the MATLAB table, it is not populated with data
    sz = [numRows, numCols];
    mTable = table('Size', sz, 'VariableTypes', variableTypes, 'VariableNames', variableNames);
    mTable.Properties.Description = matlab.lang.makeValidName(options.name);
    mTable.Properties.VariableDescriptions = variableDescriptions;

    % For all the datetime columns set them to UTC and flag this once per table
    utcWarned = false;
    for m = 1:width(mTable)
        if strcmp(variableTypes{m}, "datetime")
            if options.verbose && ~utcWarned; fprintf("Using UTC as timezone for datetimes\n"); end
            mTable.(variableNames{m}).TimeZone = "UTC";
            utcWarned = true;
        end
    end

    % tableSchema is exactly the actual MATLAB column types used to create the table
    if iscellstr(variableTypes)
        tableSchema = string(variableTypes);
    else
        error("adx:getTableAndSchemas","Expected variableTypes to be of type string or char");
    end

    % matlabSchema is the underlying MATLAB type for columns which may be stored in a cell
    % array to enable representation of null values.
    if iscellstr(matlabTypes)
        matlabSchema = string(matlabTypes);
    else
        error("adx:getTableAndSchemas","Expected matlabTypes to be of type string or char");
    end

    % kustoSchema is the Kusto type fields for the columns also stored in the table descriptions fields
    if iscellstr(variableDescriptions)
        kustoSchema = string(variableDescriptions);
    else
        error("adx:getTableAndSchemas","Expected variableDescriptions to be of type string or char");
    end
end