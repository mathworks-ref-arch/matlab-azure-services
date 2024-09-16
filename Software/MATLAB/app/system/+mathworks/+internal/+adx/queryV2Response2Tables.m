function [primaryResult, resultTables, dataSetHeader, dataSetCompletion]  = queryV2Response2Tables(v2Response, options)
    % queryV2Response2Tables Converts a v2 API response to MATLAB tables
    %
    % Required Argument:
    %  v2Response: A adx.data.models.QueryV2ResponseRaw which been processed by JSONMapper
    %
    % Optional Arguments:
    %  convertDynamics: Logical to determine if Dynamic fields are decoded or not
    %                   Default is true
    %
    %  nullPolicy: A mathworks.adx.NullPolicy to determine how nulls are handled
    %              Default is mathworks.adx.NullPolicy.ErrorLogicalInt32Int64
    %
    %  allowNullStrings: Logical to allow null strings in input. Kusto does not
    %                    store null strings but control command may return them.
    %                    Default is false.
    %  customRowDecoder: Function handle to a non default row conversion function
    %                    Function is applied to the Primary Result table only.
    %                    In certain unexpected states it is not applied.
    %
    %  useParallel: Logical to enable the use of Parallel Computing Toolbox if available
    %
    %  parallelThreshold: Threshold for row number above which Parallel Computing
    %                     Toolbox will be used, default is 1000.
    %
    %  verbose: Logical to enable additional output, default is false
    %
    % Return Values:
    %  primaryResult: The primary result as a MATLAB table
    %
    %  resultTables: The other returned tables as MATLAB tables.
    %
    %  dataSetHeader: A adx.data.models.DataSetHeader describes the high-level properties
    %                 of the returned data
    %
    %  dataSetCompletion: A adx.data.models.DataSetCompletion indicates success and other
    %                     properties of the query
    %
    % See: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/api/rest/response2

    % Copyright 2023-2024 The MathWorks, Inc.

    arguments
        v2Response adx.data.models.QueryV2ResponseRaw
        options.convertDynamics (1,1) logical = true
        options.nullPolicy (1,1) mathworks.adx.NullPolicy = mathworks.adx.NullPolicy.ErrorLogicalInt32Int64
        options.allowNullStrings (1,1) logical = false
        options.customRowDecoder function_handle = function_handle.empty
        options.useParallel (1,1) logical = false
        options.parallelThreshold (1,1) int32 = 1000;
        options.verbose (1,1) logical = false
    end

    % Should be at least 3 frames if progressive or not
    if numel(v2Response) < 3
        error("adx:queryV2Response2Tables","Expected at least 3 frames in the response, found: %d", numel(v2Response));
    end

    % Used if error or cancelled and return early
    primaryResult = table.empty;
    resultTables = {};

    % Will store the resulting headers and tables
    dataSetHeader = v2Response(1).getDataSetHeader();
    if options.verbose; printTableProps(dataSetHeader); end

    dataSetCompletion = v2Response(end).getDataSetCompletionFrame;
    if options.verbose; printTableProps(dataSetCompletion); end
    
    if dataSetCompletion.HasErrors
        fprintf("Error reported by Azure Data Explorer, skipping converting results to table\n");
        if isprop(dataSetCompletion, "OneApiErrors") && isstruct(dataSetCompletion.OneApiErrors)
            if isfield(dataSetCompletion.OneApiErrors, "error")
                fprintf("Error returned by Azure Data Explorer:\n");
                disp(dataSetCompletion.OneApiErrors.error);
            else
                fprintf("Expected OneApiErrors error field not found, unable to display error message\n");
            end
        else
            fprintf("Expected OneApiErrors property not found, unable to display error message\n");
        end
        return;
    end

    if dataSetCompletion.Cancelled
        fprintf("Query cancelled, skipping converting results to table\n");
        return;
    end


    if dataSetHeader.IsProgressive
        [progressSequence, progressIndex, tableHeader, tableFragment, tableProgress, dataTables] = populateProgressiveDataTables(v2Response, options.verbose);
        args = {"nullPolicy", options.nullPolicy, "allowNullStrings", options.allowNullStrings,...
            "useParallel", options.useParallel, "parallelThreshold", options.parallelThreshold,...
            "customRowDecoder", options.customRowDecoder, "verbose", options.verbose};
        primaryResult = tableFromFragments(progressSequence, progressIndex, tableHeader, tableFragment, tableProgress, options.convertDynamics, args{:});
        resultTables = tablesFromDataTables(dataTables, options.convertDynamics, options.nullPolicy, verbose=options.verbose);
    else
        % There should be 1 DataTable for each Table in non progressive mode
        dataTables = populateNonProgressiveDataTables(v2Response, options.verbose);
        if isempty(dataTables)
            error("adx:queryV2Response2Tables","No DataTable frame(s) found");
        end
        [primaryResult, resultTables] = nonProgressiveMode(dataTables, options.convertDynamics, options.nullPolicy, options.allowNullStrings, options.useParallel, options.parallelThreshold, options.customRowDecoder, options.verbose);
    end
end


function [progressSequence, progressIndex, tableHeader, tableFragment, tableProgress, dataTables] = populateProgressiveDataTables(v2Response, verbose)
    tableHeader = adx.data.models.TableHeader.empty;
    tableFragment = adx.data.models.TableFragment.empty;
    tableProgress = adx.data.models.TableProgress.empty;
    tableCompletion = adx.data.models.TableCompletion.empty;
    dataTables = adx.data.models.DataTables;
    progressSequence = string.empty;
    progressIndex = int32.empty;

    for n = 2:numel(v2Response)-1
        if isprop(v2Response(n), 'FrameType')
            switch (v2Response(n).FrameType)
                case 'TableHeader'
                    tableHeader(end+1) = adx.data.models.TableHeader(...
                        'TableId', v2Response(n).TableId,...
                        'TableKind', v2Response(n).TableKind,...
                        'TableName', v2Response(n).TableName,...
                        'Columns', v2Response(n).Columns); %#ok<AGROW>
                    if numel(tableHeader) > 1
                        warning("adx:queryV2Response2Tables","More than one TableHeader received")
                    end
                    if verbose; printTableProps(tableHeader(end)); end

                case 'TableFragment'
                    tableFragment(end+1) = adx.data.models.TableFragment(...
                        'TableId', v2Response(n).TableId,...
                        'FieldCount', v2Response(n).FieldCount,...
                        'TableFragmentType', v2Response(n).TableFragmentType,...
                        'Rows', v2Response(n).Rows); %#ok<AGROW>
                    if verbose; printTableProps(tableFragment(end)); end
                    progressSequence(end+1) = "Fragment"; %#ok<AGROW>
                    progressIndex(end+1) = numel(tableFragment); %#ok<AGROW>

                case 'TableProgress'
                    tableProgress(end+1) = adx.data.models.TableProgress(...
                        'TableId', v2Response(n).TableId,...
                        'TableProgress', v2Response(n).TableProgressProp); %#ok<AGROW>
                    if verbose; printTableProps(tableProgress(end)); end
                    progressSequence(end+1) = "Progress"; %#ok<AGROW>
                    progressIndex(end+1) = numel(tableProgress); %#ok<AGROW>

                case 'TableCompletion'
                    tableCompletion(end+1) = adx.data.models.TableCompletion(...
                        'TableId', v2Response(n).TableId,...
                        'RowCount', v2Response(n).RowCount); %#ok<AGROW>
                    if numel(tableHeader) > 1
                        warning("adx:queryV2Response2Tables","More than one TableHeader received")
                    end
                    if verbose; printTableProps(tableCompletion(end)); end

                case 'DataTable'
                    dataTables.Tables(end+1) = adx.data.models.DataTable(...
                        'TableId', v2Response(n).TableId,...
                        'TableKind', v2Response(n).TableKind,...
                        'TableName', v2Response(n).TableName,...
                        'Columns', v2Response(n).Columns,...
                        'Rows', v2Response(n).Rows);
                    if verbose; printTableProps(dataTables.Tables(end)); end

                otherwise
                    error("adx:queryV2Response2Tables","Unexpected FrameType: %s", v2Response(n).FrameType);
            end
        else
            error("adx:queryV2Response2Tables","Expected frame: %d to have a FrameType property", n);
        end
    end
end


function dataTables = populateNonProgressiveDataTables(v2Response, verbose)
    % Populate tables excl. header and completion 1st & last
    dataTables = adx.data.models.DataTables;
    for n = 2:numel(v2Response)-1
        if isprop(v2Response(n), 'FrameType')
            if strcmpi(v2Response(n).FrameType, "datatable")
                dataTables.Tables(end+1) = adx.data.models.DataTable(...
                    'TableId', v2Response(n).TableId,...
                    'TableKind', v2Response(n).TableKind,...
                    'TableName', v2Response(n).TableName,...
                    'Columns', v2Response(n).Columns,...
                    'Rows', v2Response(n).Rows);
                if verbose; printTableProps(dataTables.Tables(end)); end
            else
                error("adx:queryV2Response2Tables","Expected only DataTable between DataSetHeader & DataSetCompletion, found: %s", v2Response(end).FrameType);
            end
        else
            error("adx:queryV2Response2Tables","Expected frame: %d to have a FrameType property", n);
        end
    end
end


function printTableProps(obj)
    % printTableProps Print debug info for an object
    arguments
        obj (1,1)
    end

    fprintf("%s\n", class(obj));
    propsList = properties(obj);
    for n = 1:numel(propsList)
        currProp = propsList{n};
        currObj = obj.(currProp);
        if isnumeric(currObj)
            if islogical(currObj)
                fprintf("  %s: %s\n", currProp, string(currObj));
            elseif isa(currObj, 'double')
                fprintf("  %s: %f\n", currProp, currObj);
            else
                fprintf("  %s: %d\n", currProp, currObj);
            end
        elseif isStringScalar(currObj) || ischar(currObj)
            fprintf("  %s: %s\n", currProp, currObj);
        elseif isenum(currObj)
            fprintf("  %s: %s\n", currProp, string(currObj));
        elseif isa(currObj, "adx.data.models.Column")
            fprintf("  %s #: %d\n", currProp, numel(currObj));
        elseif isa(currObj, "adx.data.models.Row")
            fprintf("  %s #: %s\n", currProp, numel(currObj));
        else
            fprintf("  %s: class: %s\n", currProp, class(currObj));
        end
    end
end


function [mTable, matlabSchema, kustoSchema] = tableFromRowsAndColumns(rows, columns, convertDynamics, options)
    % tableFromRowsAndColumns Creates a MATLAB table from Rows & Cols
    % The schemas are returned as a string arrays
    % The table contents are populated from the rows

    arguments
        rows string
        columns (1,:) adx.data.models.Column
        convertDynamics (1,1) logical
        options.name (1,1) string = ""
        options.kind (1,1) adx.data.models.TableKind = adx.data.models.TableKind.Unknown
        options.nullPolicy (1,1) mathworks.adx.NullPolicy = mathworks.adx.NullPolicy.ErrorLogicalInt32Int64
        options.allowNullStrings (1,1) logical = false
        options.useParallel (1,1) logical = false
        options.verbose (1,1) logical = true
        options.parallelThreshold (1,1) int32 = 1000;
        options.customRowDecoder function_handle = function_handle.empty
    end

    % Create the table and a cell array of the same size
    [mTable, tableSchema, matlabSchema, kustoSchema] = mathworks.internal.adx.getTableAndSchemas(columns, numel(rows), name=options.name, nullPolicy=options.nullPolicy, verbose=options.verbose);

    if isfield(options, 'name') && eq(options.kind, adx.data.models.TableKind.PrimaryResult) && ~isempty(options.customRowDecoder)
        cArray = options.customRowDecoder(rows, tableSchema, matlabSchema, kustoSchema, convertDynamics, options.nullPolicy, options.allowNullStrings, options.useParallel, options.parallelThreshold, options.verbose);
    else
        % Default decoder using getRowsWithSchema
        cArray = mathworks.internal.adx.getRowsWithSchema(rows, tableSchema, matlabSchema, kustoSchema, convertDynamics, options.nullPolicy, options.allowNullStrings, options.useParallel, options.parallelThreshold, options.verbose);
    end

    if height(cArray) ~= height(mTable)
        error("adx:queryV2Response2Tables","Invalid number of decoded rows, expected: %d, found: %d", height(mTable), height(cArray));
    end
    if width(cArray) ~= width(mTable)
        error("adx:queryV2Response2Tables","Invalid number of decoded columns, expected: %d, found: %d", width(mTable), width(cArray));
    end

    if numel(rows) > 10000 && options.verbose
        disp("Formatting results");
    end
    % Assign the columns to the table, write cells without an extra layer of nesting
    % If rows was empty then cArray can be empty i.e. 0xN, return a 0xN table
    if height(cArray) > 0
        for n = 1:width(mTable)
            if strcmp(tableSchema(n), "cell")
                mTable{:,n} = cArray(:,n);
            else
                mTable(:,n) = cArray(:,n);
            end
        end
    end
end


function mTables = tablesFromDataTables(dataTables, convertDynamics, nullPolicy, options)
    % tablesFromDataTables Creates a cell array of MATLAB tables from and array of dataTables
    % Optionally prints some output.
    arguments
        dataTables (1,1) adx.data.models.DataTables
        convertDynamics (1,1) logical
        nullPolicy (1,1) mathworks.adx.NullPolicy
        options.verbose (1,1) logical = false
    end

    numTables = numel(dataTables.Tables);
    mTables = cell(numTables, 1);
    for n = 1:numTables
        if options.verbose
            fprintf("Converting DataTable\n");
            printTableProps(dataTables.Tables(n))
        end
        [mTables{n}, ~] = tableFromRowsAndColumns(dataTables.Tables(n).Rows, dataTables.Tables(n).Columns, convertDynamics, name=dataTables.Tables(n).TableName, nullPolicy=nullPolicy, verbose=options.verbose);
    end
end


function fragmentResult = tableFromFragments(progressSequence, progressIndex, tableHeader, tableFragment, tableProgress, convertDynamics, options)
    % tableFromFragments
    arguments
        progressSequence string {mustBeNonzeroLengthText}
        progressIndex int32
        tableHeader (1,1) adx.data.models.TableHeader
        tableFragment adx.data.models.TableFragment
        tableProgress (1,1) adx.data.models.TableProgress
        convertDynamics (1,1) logical
        options.allowNullStrings (1,1) logical = false
        options.nullPolicy (1,1) mathworks.adx.NullPolicy = mathworks.adx.NullPolicy.ErrorLogicalInt32Int64
        options.useParallel (1,1) logical = false
        options.parallelThreshold (1,1) int32 = 1000;
        options.customRowDecoder function_handle = function_handle.empty
        options.verbose (1,1) logical = false
    end

    % tableFromFragments Uses Table Fragments to build a table
    if options.verbose; fprintf("Creating fragment result table\n"); end

    % No point processing fragments that come before a replace fragment
    % Loop through fragments and find the last fragment of type DataReplace
    % Note the index as the effective starting point in the fragments table
    startFragment = 1;
    for n = 1:numel(tableFragment)
        if tableFragment(n).TableFragmentType == adx.data.models.TableFragmentType.DataReplace
            startFragment = n;
        end
        % This should match
        if tableFragment(n).FieldCount ~= numel(tableHeader.Columns)
            error("adx:queryV2Response2Tables","Mismatch in fieldcount: %d and column number: %d for fragment: %d", tableFragment(n).FieldCount, numel(tableHeader.Columns), n);
        end
    end
    if options.verbose; fprintf("Start fragment: %d of: %d\n", startFragment, numel(tableFragment)); end

    % progressSequence & progressIndex are arrays that note the table type,
    % fragment or progress in order and the corresponding index into the
    % respective fragment or progress tables
    if numel(progressSequence) ~= (numel(tableFragment) + numel(tableProgress))
        error("adx:queryV2Response2Tables","Number of fragment and progress tables mismatch");
    end
    if numel(progressSequence) ~= numel(progressIndex)
        error("adx:queryV2Response2Tables","Number of progressSequence and progressIndex mismatch");
    end

    % Count the number of Rows in the fragments post any DataReplace fragments
    rowCount = 0;
    for n = startFragment:numel(tableFragment)
        rowCount = rowCount + numel(tableFragment(n).Rows);
    end

    % Create an array to hold the consolidated fragments rows
    rowsArray = strings(rowCount, 1);
    offset=0;
    for n = startFragment:numel(tableFragment)
        rowsArray(offset+1:offset+numel(tableFragment(n).Rows)) = tableFragment(n).Rows(:);
        offset = offset + numel(tableFragment(n).Rows);
    end

    args = {"name", tableHeader.TableName, "kind", tableHeader.TableKind,...
        "allowNullStrings", options.allowNullStrings, "nullPolicy", options.nullPolicy,...
        "customRowDecoder", options.customRowDecoder,...
        "useParallel", options.useParallel, "parallelThreshold" options.parallelThreshold};

    [fragmentResult, ~] = tableFromRowsAndColumns(rowsArray, tableHeader.Columns, convertDynamics, args{:});
end


function [result, resultTables] = nonProgressiveMode(dataTables, convertDynamics, nullPolicy, allowNullStrings, useParallel, parallelThreshold, customRowDecoder, verbose)
    % nonProgressiveMode Convert DataTable frame(s) to table(s)
    arguments
        dataTables (1,1) adx.data.models.DataTables
        convertDynamics (1,1) logical
        nullPolicy (1,1) mathworks.adx.NullPolicy
        allowNullStrings (1,1) logical
        useParallel (1,1) logical
        parallelThreshold (1,1) int32
        customRowDecoder function_handle
        verbose (1,1) logical
    end

    queryPropertiesFound = false;
    primaryResultFound = false;
    queryCompletionInformationFound = false;
    resultTables = cell(numel(dataTables.Tables), 1);
    primaryResultIndex = 0;

    if verbose; fprintf("Creating result table(s)\n"); end
    if verbose; fprintf("Number of datatables: %d\n", numel(dataTables.Tables)); end
    for n = 1:numel(dataTables.Tables)
        if ~isprop(dataTables.Tables(n), 'Columns')
            error("adx:queryV2Response2Tables","Columns not found in DataTable");
        end
        if ~isprop(dataTables.Tables(n), 'Rows')
            error("adx:queryV2Response2Tables","Rows not found in DataTable");
        end
        % TODO check for multiple writes and missing properties
        if dataTables.Tables(n).TableKind == adx.data.models.TableKind.QueryProperties
            queryPropertiesFound = true;
            if verbose; fprintf("QueryProperties table found\n"); end
        end
        if dataTables.Tables(n).TableKind == adx.data.models.TableKind.PrimaryResult
            primaryResultFound = true;
            primaryResultIndex = n;
            if verbose; fprintf("Primary result found\n"); end
        end
        if dataTables.Tables(n).TableKind == adx.data.models.TableKind.QueryCompletionInformation
            queryCompletionInformationFound = true;
            if verbose; fprintf("Completion table found\n"); end
        end

        args = {"nullPolicy", nullPolicy, "allowNullStrings", allowNullStrings, "useParallel", useParallel,...
            "parallelThreshold", parallelThreshold, "verbose", verbose, "customRowDecoder", customRowDecoder,...
            "name", dataTables.Tables(n).TableName, "kind", dataTables.Tables(n).TableKind};

        resultTables{n} = tableFromRowsAndColumns(dataTables.Tables(n).Rows, dataTables.Tables(n).Columns, convertDynamics, args{:});
    end

    % The result we really want should always be in the second table
    % otherwise return and empty table
    if primaryResultIndex == 0
        warning("adx:queryV2Response2Tables","PrimaryResult table was not found returning an empty table");
        result = table;
    else
        if primaryResultIndex ~= 2
            if verbose; fprintf("primaryResultIndex not of expected value of 2: %d\n", primaryResultIndex); end
        end
        result = resultTables{primaryResultIndex};
        if ~istable(result)
            warning("adx:queryV2Response2Tables","Returning a result which is not of type table");
        end
    end

    % Check that the expected tables were found (non progressive case)
    if ~queryPropertiesFound
        warning("adx:queryV2Response2Tables","QueryProperties table not found");
    end
    if ~primaryResultFound
        warning("adx:queryV2Response2Tables","PrimaryResult table not found");
    end
    if ~queryCompletionInformationFound
        warning("adx:queryV2Response2Tables","QueryCompletionInformation table not found");
    end
end
