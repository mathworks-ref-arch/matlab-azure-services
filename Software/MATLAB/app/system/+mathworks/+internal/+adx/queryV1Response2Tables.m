function [primaryResult, responseTables] = queryV1Response2Tables(response, options)
    % queryV1Response2Tables Convert a v1 API response to MATLAB tables
    %
    % Required argument
    %  response: A adx.data.models.QueryV1ResponseRaw as returned by queryRun().
    %
    % Optional arguments
    %  nullPolicy: Enumeration to determine how null values should be handled.
    %              Default is mathworks.adx.NullPolicy.ErrorLogicalInt32Int64
    %
    %  convertDynamics: Logical to determine if dynamic fields should be decoded
    %                   from JSON. Default is true.
    %
    %  allowNullStrings: Logical to allow null strings in input. Kusto does not
    %                    store null strings but control command may return them.
    %                    Default is false.
    %
    %  useParallel: Logical to enable the use of Parallel Computing Toolbox if available
    %
    %  parallelThreshold: Threshold for row number above which Parallel Computing
    %                     Toolbox will be used, default is 1000.
    %
    %  customRowDecoder: Function handle to a non default row conversion function
    %                    Function is applied to the Primary Result table only.
    %                    In certain unexpected states it is not applied.
    %
    %  verbose: Logical to enable additional output, default is false.
    %
    % Return values
    %  primaryResult: The primary result as a MATLAB table.
    %
    %  resultTables: The other returned tables as MATLAB tables.

    % Copyright 2023-2024 The MathWorks, Inc.

    arguments
        response (1,1) adx.data.models.QueryV1ResponseRaw
        options.nullPolicy (1,1) mathworks.adx.NullPolicy = mathworks.adx.NullPolicy.ErrorLogicalInt32Int64
        options.convertDynamics (1,1) logical = true
        options.allowNullStrings (1,1) logical = false
        options.useParallel (1,1) logical = false
        options.parallelThreshold (1,1) int32 = 1000;
        options.customRowDecoder function_handle = function_handle.empty
        options.verbose (1,1) logical = false;
    end

    if ~isprop(response, 'Tables')
        error("adx:queryV1Response2Tables","Expected Tables property not found");
    end

    if numel(response.Tables) == 0
        primaryResult = table.empty; % In case Primary result is not found
        responseTables = {};
        warning("adx:queryV1Response2Tables", "No tables found in response");
    elseif numel(response.Tables) == 1 %#ok<ISCL>
        % v1 can return 1 table
        tableName = response.Tables(1).TableName;
        primaryResult = decodeTable(true, tableName, response.Tables(1), options.nullPolicy, options.convertDynamics, options.allowNullStrings, options.useParallel, options.parallelThreshold, options.customRowDecoder, options.verbose);
        responseTables = {};
    else
        % The table of contents table should be the last one
        % decode it to get the primary result
        responseTables = {};
        toc = decodeTable(false, "Table of Contents", response.Tables(end), options.nullPolicy, options.convertDynamics, options.allowNullStrings, options.useParallel, options.parallelThreshold, function_handle.empty, options.verbose);
        colNames = ["Ordinal", "Kind", "Name", "Id", "PrettyName"];
        % Pretty Name is not always present
        varNames = toc.Properties.VariableNames;
        if istable(toc) && any(contains(varNames, colNames(1))) && any(contains(varNames, colNames(2))) && any(contains(varNames, colNames(3))) && any(contains(varNames, colNames(4)))
            primaryIdx = 0;
            for n = 1:height(toc)
                if strcmp(toc.Name(n), "PrimaryResult")
                    primaryIdx = toc.Ordinal(n)+1;
                    break;
                end
            end
            % Should be a fatal error
            if primaryIdx > numel(response.Tables)
                error("adx:queryV1Response2Tables", "PrimaryResult index: %d, greater than the number of tables: %d", primaryIdx, numel(response.Tables));
            end
        else
            primaryIdx = 0; % An error state meaning that primary result was not found or the ToC is corrupt
            warning("adx:queryV1Response2Tables", "Table of contents not as expected");
        end

        if primaryIdx == 0
            % return the first table as primary as a best effort
            primaryResult = decodeTable(true, response.Tables(1).TableName, response.Tables(1), options.nullPolicy, options.convertDynamics, options.allowNullStrings, options.useParallel, options.parallelThreshold, function_handle.empty, options.verbose);
            if options.verbose
                fprintf("Warning: PrimaryResult not found in response, using first table\n");
            end
        else
            primaryResult = decodeTable(true, "PrimaryResult", response.Tables(primaryIdx), options.nullPolicy, options.convertDynamics, options.allowNullStrings, options.useParallel, options.parallelThreshold, options.customRowDecoder, options.verbose);
        end

        for n = 1:numel(response.Tables)-1 % Skip the ToC table which should be last and is already decoded
            if n ~= primaryIdx
                tableName = string(toc.Name(n));
                responseTables{end+1} = decodeTable(false, tableName, response.Tables(n), options.nullPolicy, options.convertDynamics, options.allowNullStrings, options.useParallel, options.parallelThreshold, function_handle.empty, options.verbose); %#ok<AGROW>
            end
        end
        responseTables{end+1} = toc;
    end
end


function mTable = decodeTable(isPrimary, tableName, responseTable, nullPolicy, convertDynamics, allowNullStrings, useParallel, parallelThreshold, customRowDecoder, verbose)
    numRows = numel(responseTable.Rows);

    % Create the unpopulated table and get the schemas
    [mTable, tableSchema, matlabSchema, kustoSchema] = mathworks.internal.adx.getTableAndSchemas(responseTable.Columns, numRows, name=tableName, nullPolicy=nullPolicy, verbose=verbose);

    if isPrimary && ~isempty(customRowDecoder)
        cArray = options.customRowDecoder(responseTables.rows, tableSchema, matlabSchema, kustoSchema, convertDynamics, nullPolicy, allowNullStrings, useParallel, parallelThreshold, verbose);
    else
        % Default decoder using getRowsWithSchema
        cArray = mathworks.internal.adx.getRowsWithSchema(responseTable.Rows, tableSchema, matlabSchema, kustoSchema, convertDynamics, nullPolicy, allowNullStrings, useParallel, parallelThreshold, verbose);
    end

    if height(cArray) ~= height(mTable)
        error("adx:queryV1Response2Tables","Invalid number of decoded rows, expected: %d, found: %d", height(mTable), height(cArray));
    end
    if width(cArray) ~= width(mTable)
        error("adx:queryV1Response2Tables","Invalid number of decoded columns, expected: %d, found: %d", width(mTable), width(cArray));
    end

    if numRows > 10000 && verbose
        disp("Formatting results");
    end

    % Assign the columns to the table, write cells without an extra layer of nesting
    if height(cArray) > 0
        for m = 1:width(mTable)
            if strcmp(tableSchema(m), "cell")
                mTable{:,m} = cArray(:,m);
            else
                mTable(:,m) = cArray(:,m);
            end
        end
    end
end