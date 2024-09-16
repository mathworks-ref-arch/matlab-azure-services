function cArray = exampleCustomRowDecoder(rows, tableSchema, matlabSchema, kustoSchema, convertDynamics, nullPolicy, allowNullStrings, useParallel, parallelThreshold, verbose)
    % exampleCustomRowDecoder Example of a custom JSON parser function
    % Sample decoder that handles an array of rows of the form:
    %  [128030544,1.0,"myStringValue-1"]
    % with fields of types int64, double and string.
    %
    % It will not process other data and is intended for speed rather than
    % strict correctness or robustness.
    %
    % The custom decoder is applied to the PrimaryResult rows field only.
    %
    % It is required to return a cell array of size number of rows by the
    % number of columns that can be converted to a MATLAB table with the
    % given schema.
    %
    % It is not required to respect input arguments flags if foreknowledge of
    % returned data permits it.
    %
    % Custom decoders are applied to nonprogressive KQL API v2 mode queries only.
    % If support for other query types is required contact MathWorks.
    %
    % Example:
    %  query = sprintf('table("%s", "all")', tableName);
    %  crd = @mathworks.internal.adx.exampleCustomRowDecoder;
    %  [result, success] = mathworks.adx.run(query, customRowDecoder=crd);
    %
    % For a generic decoder see: getRowsWithSchema.

    % Copyright 2024 The MathWorks, Inc.

    arguments
        rows string
        tableSchema string
        matlabSchema string
        kustoSchema string
        convertDynamics (1,1) logical %#ok<INUSA>
        nullPolicy (1,1) mathworks.adx.NullPolicy = mathworks.adx.NullPolicy.ErrorLogicalInt32Int64 %#ok<INUSA>
        allowNullStrings (1,1) logical = false %#ok<INUSA>
        useParallel (1,1) logical = false
        parallelThreshold (1,1) int32 = 1000;
        verbose (1,1) logical = false
    end

    numCols = numel(matlabSchema);
    if numel(tableSchema) ~= numCols
        error("adx:getRowWithSchema", "Size of table schema: %d, does not match the MATLAB schema: %d", numel(tableSchema), numCols);
    end
    if numel(kustoSchema) ~= numCols
        error("adx:getRowWithSchema", "Size of Kusto schema: %d, does not match the MATLAB schema: %d", numel(kustoSchema), numCols);
    end

    if numel(rows) > 1000 && verbose
        showCount = true;
    else
        showCount = false;
    end

    % The output will all be in a cell array to be assigned to a cell array row and later to a table
    cArray = cell(numel(rows), numCols);

    if useParallel && numel(rows) >= parallelThreshold && ~isempty(ver('parallel'))
        pool = gcp('nocreate');
        if isempty(pool)
            % Note the default decoder requires a process based pool as opposed to "Threads"
            % because of its use of Java, which might otherwise be preferable
            % pool = parpool('Threads');
            pool = parpool('Processes');
        end

        if isa(pool, 'parallel.ThreadPool')
            doParfor = true;
        elseif isprop(pool,'Cluster') &&  isprop(pool.Cluster,'Profile') && strcmp(pool.Cluster.Profile, 'Processes')
            doParfor = true;
        else
            % Overhead of a remote cluster may not be justified
            fprintf("Found a parpool which is not process or thread based, rows will be processed serially.\n");
            doParfor = false;
        end
    else
        doParfor = false;
    end

    if doParfor
        if showCount
            fprintf("Processing: %d rows in parallel using: %d workers with a custom row decoder\n", numel(rows), pool.NumWorkers);
        end
        parfor rowIdx = 1:numel(rows)
            cArray(rowIdx,:) = procRow(rows(rowIdx));
        end
    else
        fprintf("Processing: %d rows serially using a custom row decoder\n", numel(rows));
        for rowIdx = 1:numel(rows)
            if showCount && mod(rowIdx, 500) == 0
                fprintf("Processing row: %d of %d\n", rowIdx, numel(rows))
            end
            cArray(rowIdx,:) = procRow(rows(rowIdx));
        end
    end
end


function result = procRow(row)
    % Row format is well know so can skip some checks
    % Expecting only one [
    row = strip(row, "left", "[");
    % Expecting only one ]
    row = strip(row, "right", "]");
    fields = split(row, ",");
    l =  sscanf(fields(1), "%ld");
    d =  str2double(fields(2));
    % Expecting only one layer of quotes
    result = {l; d; strip(fields(3),"both", '"')};
end