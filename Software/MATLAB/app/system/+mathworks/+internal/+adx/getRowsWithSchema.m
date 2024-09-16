function cArray = getRowsWithSchema(rows, tableSchema, matlabSchema, kustoSchema, convertDynamics, nullPolicy, allowNullStrings, useParallel, parallelThreshold, verbose)
    % GETROWSWITHSCHEMA Extract rows of data as a cell array from a JSON string using schemas
    % For detail on dynamic values see:
    %   https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/scalar-data-types/dynamic

    % Copyright 2024 The MathWorks, Inc.

    arguments
        rows string
        tableSchema string
        matlabSchema string
        kustoSchema string
        convertDynamics (1,1) logical
        nullPolicy (1,1) mathworks.adx.NullPolicy = mathworks.adx.NullPolicy.ErrorLogicalInt32Int64
        allowNullStrings (1,1) logical = false
        useParallel (1,1) logical = false
        parallelThreshold (1,1) int32 = 1000;
        verbose (1,1) logical = false
    end

    numCols = numel(matlabSchema);
    if numel(tableSchema) ~= numCols
        error("adx:getRowsWithSchema", "Size of table schema: %d, does not match the MATLAB schema: %d", numel(tableSchema), numCols);
    end
    if numel(kustoSchema) ~= numCols
        error("adx:getRowsWithSchema", "Size of Kusto schema: %d, does not match the MATLAB schema: %d", numel(kustoSchema), numCols);
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
            pool = parpool('Processes');
        end
        
        if isa(pool, 'parallel.ThreadPool')
            fprintf("Found a parpool which thread based, a process based pool is required, rows will be processed serially.\n");
            doParfor = false;
        elseif isprop(pool,'Cluster') &&  isprop(pool.Cluster,'Profile') && strcmp(pool.Cluster.Profile, 'Processes')
            doParfor = true;
        else
            fprintf("Found a parpool which is not process based, rows will be processed serially.\n");
            doParfor = false;
        end
    else
        doParfor = false;
    end

    if doParfor % TODO clean up code duplication
        if showCount
            fprintf("Processing: %d rows in parallel using: %d workers\n", numel(rows), pool.NumWorkers);
        end
        parfor rowIdx = 1:numel(rows)

            json = com.google.gson.JsonParser().parse(rows(rowIdx));
            if json.size ~= numCols
                error("adx:getRowsWithSchema", "Size of JSON array: %d, does not match the MATLAB schema: %d, row: %d", json.size, numCols, rowIdx);
            end

            % Ensure input is always an array
            if (~json.isJsonArray())
                j = com.google.gson.JsonArray();
                j.add(json);
                json = j;
            end

            for colIdx = 1:numCols
                % Get the JSON value
                curElement = json.get(colIdx-1);
                switch lower(matlabSchema(colIdx)) %#ok<PFBNS>
                    % Functions can also return missing/NaT/NaN
                    case "logical"
                        cArray{rowIdx, colIdx} = convert2Logical(curElement, nullPolicy, rowIdx, colIdx);
                    case "int32"
                        cArray{rowIdx, colIdx} = convert2Int32(curElement, nullPolicy, rowIdx, colIdx);
                    case "int64"
                        cArray{rowIdx, colIdx} = convert2Int64(curElement, nullPolicy, rowIdx, colIdx);
                    case "double"
                        cArray{rowIdx, colIdx} = convert2Double(curElement, nullPolicy, rowIdx, colIdx);
                    case "string"
                        cArray{rowIdx, colIdx} = convert2String(curElement, kustoSchema(colIdx), nullPolicy, allowNullStrings, rowIdx, colIdx); %#ok<PFBNS>
                    case "datetime"
                        cArray{rowIdx, colIdx} = convert2Datetime(curElement, nullPolicy, rowIdx, colIdx);
                    case "duration"
                        cArray{rowIdx, colIdx} = convert2Duration(curElement, nullPolicy, rowIdx, colIdx);
                    case "cell"
                        cArray{rowIdx, colIdx} = convert2Cell(curElement, kustoSchema(colIdx), convertDynamics, nullPolicy, rowIdx, colIdx);
                    otherwise
                        error("adx:getRowsWithSchema", "Unexpected MATLAB schema type: %s", matlabSchema(colIdx));
                end
            end
        end

    else
        for rowIdx = 1:numel(rows)
            % Some feed back for "big" queries
            if showCount && mod(rowIdx, 500) == 0
                fprintf("Processing row: %d of %d\n", rowIdx, numel(rows))
            end

            json = com.google.gson.JsonParser().parse(rows(rowIdx));
            if json.size ~= numCols
                error("adx:getRowsWithSchema", "Size of JSON array: %d, does not match the MATLAB schema: %d, row: %d", json.size, numCols, rowIdx);
            end

            % Ensure input is always an array
            if (~json.isJsonArray())
                j = com.google.gson.JsonArray();
                j.add(json);
                json = j;
            end

            for colIdx = 1:numCols
                % Get the JSON value
                curElement = json.get(colIdx-1);
                switch lower(matlabSchema(colIdx))
                    % Functions can also return missing/NaT/NaN
                    case "logical"
                        cArray{rowIdx, colIdx} = convert2Logical(curElement, nullPolicy, rowIdx, colIdx);
                    case "int32"
                        cArray{rowIdx, colIdx} = convert2Int32(curElement, nullPolicy, rowIdx, colIdx);
                    case "int64"
                        cArray{rowIdx, colIdx} = convert2Int64(curElement, nullPolicy, rowIdx, colIdx);
                    case "double"
                        cArray{rowIdx, colIdx} = convert2Double(curElement, nullPolicy, rowIdx, colIdx);
                    case "string"
                        cArray{rowIdx, colIdx} = convert2String(curElement, kustoSchema(colIdx), nullPolicy, allowNullStrings, rowIdx, colIdx);
                    case "datetime"
                        cArray{rowIdx, colIdx} = convert2Datetime(curElement, nullPolicy, rowIdx, colIdx);
                    case "duration"
                        cArray{rowIdx, colIdx} = convert2Duration(curElement, nullPolicy, rowIdx, colIdx);
                    case "cell"
                        cArray{rowIdx, colIdx} = convert2Cell(curElement, kustoSchema(colIdx), convertDynamics, nullPolicy, rowIdx, colIdx);
                    otherwise
                        error("adx:getRowsWithSchema", "Unexpected MATLAB schema type: %s", matlabSchema(colIdx));
                end
            end
        end
    end
end


function val = convert2Cell(curElement, kustoSchema, convertDynamics, nullPolicy, rowIdx, colIdx)
    if strcmpi(kustoSchema, "dynamic")
        if convertDynamics
            if curElement.isJsonPrimitive
                if curElement.isBoolean
                    val = convert2Logical(curElement, nullPolicy);
                elseif curElement.isNumber
                    val = convert2Double(curElement, nullPolicy);
                elseif curElement.isString
                    try
                        charVal = char(curElement.getAsString);
                        if startsWith(charVal, "{") && endsWith(charVal, "}")
                            val = jsondecode(charVal);
                        else
                            % Add quotes that get removed by getAsString
                            val = jsondecode(['"', charVal, '"']);
                        end
                    catch
                        fprintf("Warning: Unable to jsondecode dynamic primitive value, (%d,%d)\n", rowIdx, colIdx);
                        val = char(curElement.getAsString);
                    end
                else
                    error("adx:getRowsWithSchema", "Unexpected JSON primitive type, (%d,%d)", rowIdx, colIdx);
                end
            elseif curElement.isJsonNull
                switch nullPolicy
                    case {mathworks.adx.NullPolicy.AllowAll, mathworks.adx.NullPolicy.ErrorLogicalInt32Int64, mathworks.adx.NullPolicy.Convert2Double}
                        val = missing;
                    case mathworks.adx.NullPolicy.ErrorAny
                        error("adx:getRowsWithSchema", "Null values are not supported: mathworks.adx.NullPolicy.ErrorAny,(%d,%d)", rowIdx, colIdx);
                    otherwise
                        error("adx:getRowsWithSchema", "Unexpected NullPolicy: %s", nullPolicy);
                end
            elseif curElement.isJsonArray
                if curElement.isEmpty
                    switch nullPolicy
                        case {mathworks.adx.NullPolicy.AllowAll, mathworks.adx.NullPolicy.ErrorLogicalInt32Int64, mathworks.adx.NullPolicy.Convert2Double}
                            val = missing;
                        case mathworks.adx.NullPolicy.ErrorAny
                            error("adx:getRowsWithSchema", "Null values are not supported: mathworks.adx.NullPolicy.ErrorAny, (%d,%d)\n", rowIdx, colIdx);
                        otherwise
                            error("adx:getRowsWithSchema", "Unexpected NullPolicy: %s", nullPolicy);
                    end
                else
                    try
                        val = jsondecode(char(curElement.toString));
                    catch
                        fprintf("Warning: Unable to jsondecode dynamic array value, (%d,%d)\n", rowIdx, colIdx);
                        val = char(curElement.toString);
                    end
                end
            elseif curElement.isJsonObject
                try
                    val = jsondecode(char(curElement.toString));
                catch
                    fprintf("Warning: Unable to jsondecode dynamic object value, (%d,%d)\n", rowIdx, colIdx);
                    val = char(curElement.toString);
                end
            else
                error("adx:getRowsWithSchema", "Unexpected JSON primitive type in dynamic, (%d,%d)", rowIdx, colIdx);
            end
        else
            % Don't convert the dynamic value just pass the string
            if curElement.isJsonArray || curElement.isJsonObject
                val = char(curElement.toString);
            elseif curElement.isJsonNull
                switch nullPolicy
                    case {mathworks.adx.NullPolicy.AllowAll, mathworks.adx.NullPolicy.ErrorLogicalInt32Int64, mathworks.adx.NullPolicy.Convert2Double}
                        val = missing;
                    case mathworks.adx.NullPolicy.ErrorAny
                        error("adx:getRowsWithSchema", "Null values are not supported: mathworks.adx.NullPolicy.ErrorAny, (%d,%d)", rowIdx, colIdx);
                    otherwise
                        error("adx:getRowsWithSchema", "Unexpected NullPolicy: %s", nullPolicy);
                end
            else
                val = char(curElement.getAsString);
            end
        end
    else
        error("adx:getRowsWithSchema", "Unexpected cell type in MATLAB schema for Kusto schema type: %s, (%d,%d)", kustoSchema, rowIdx, colIdx);
    end
end


function val = convert2Logical(curElement, nullPolicy, rowIdx, colIdx)
    if curElement.isJsonPrimitive
        if nullPolicy == mathworks.adx.NullPolicy.Convert2Double
            if curElement.getAsBoolean
                val = 1;
            else
                val = 0;
            end
        else
            val = curElement.getAsBoolean;
        end
    elseif curElement.isJsonNull
        switch nullPolicy
            case mathworks.adx.NullPolicy.AllowAll
                val = missing;
            case mathworks.adx.NullPolicy.Convert2Double
                val = NaN;
            case mathworks.adx.NullPolicy.ErrorLogicalInt32Int64
                error("adx:getRowsWithSchema", "Logical null values are not supported using: mathworks.adx.NullPolicy.ErrorLogicalInt32Int64, consider using mathworks.adx.NullPolicy.AllowAll, (%d,%d)", rowIdx, colIdx);
            case mathworks.adx.NullPolicy.ErrorAny
                error("adx:getRowsWithSchema", "Null values are not supported when using: mathworks.adx.NullPolicy.ErrorAny, (%d,%d)", rowIdx, colIdx);
            otherwise
                error("adx:getRowsWithSchema", "Unexpected NullPolicy: %s", nullPolicy);
        end
    elseif curElement.isJsonArray
        error("adx:getRowsWithSchema", "JSON array not expect for a logical value, (%d,%d)", rowIdx, colIdx);
    elseif curElement.isJsonObject
        error("adx:getRowsWithSchema", "JSON object not expect for a logical value, (%d,%d)", rowIdx, colIdx);
    else
        error("adx:getRowsWithSchema", "Unexpected JSON element value, (%d,%d)", rowIdx, colIdx);
    end
end


function val = convert2Int32(curElement, nullPolicy, rowIdx, colIdx)
    if curElement.isJsonPrimitive
        if nullPolicy == mathworks.adx.NullPolicy.Convert2Double
            val = double(curElement.getAsInt);
        else
            % Will have been converted to a double from Javabut without
            % loss, so convert back to an int32
            val = int32(curElement.getAsInt);
        end
    elseif curElement.isJsonNull
        switch nullPolicy
            case mathworks.adx.NullPolicy.AllowAll
                val = missing;
            case mathworks.adx.NullPolicy.Convert2Double
                val = NaN;
            case mathworks.adx.NullPolicy.ErrorLogicalInt32Int64
                error("adx:getRowsWithSchema", "int32  null values are not supported using: mathworks.adx.NullPolicy.ErrorLogicalInt32Int64, consider using mathworks.adx.NullPolicy.AllowAll, (%d,%d)", rowIdx, colIdx);
            case mathworks.adx.NullPolicy.ErrorAny
                error("adx:getRowsWithSchema", "Null values are not support when using: mathworks.adx.NullPolicy.ErrorAny, (%d,%d)", rowIdx, colIdx);
            otherwise
                error("adx:getRowsWithSchema", "Unexpected NullPolicy: %s", nullPolicy);
        end
    elseif curElement.isJsonArray
        error("adx:getRowsWithSchema", "JSON array not expect for an int32 value, (%d,%d)", rowIdx, colIdx);
    elseif curElement.isJsonObject
        error("adx:getRowsWithSchema", "JSON object not expect for an int32 value, (%d,%d)", rowIdx, colIdx);
    else
        error("adx:getRowsWithSchema", "Unexpected JSON element value, (%d,%d)", rowIdx, colIdx);
    end
end


function val = convert2Int64(curElement, nullPolicy, rowIdx, colIdx)
    if curElement.isJsonPrimitive
        if nullPolicy == mathworks.adx.NullPolicy.Convert2Double
            % Could do the conversion transparently or in Java
            % using this approach for clarity for now
            val = double(sscanf(string(curElement.toString()), "%ld"));
        else
            val = sscanf(string(curElement.toString()), "%ld");
        end
    elseif curElement.isJsonNull
        switch nullPolicy
            case mathworks.adx.NullPolicy.AllowAll
                val = missing;
            case mathworks.adx.NullPolicy.Convert2Double
                val = NaN;
            case mathworks.adx.NullPolicy.ErrorLogicalInt32Int64
                error("adx:getRowsWithSchema", "int64 null values are not supported when using: mathworks.adx.NullPolicy.ErrorLogicalInt32Int64, consider using mathworks.adx.NullPolicy.AllowAll, (%d,%d)", rowIdx, colIdx);
            case mathworks.adx.NullPolicy.ErrorAny
                error("adx:getRowsWithSchema", "Null values are not supported when using: mathworks.adx.NullPolicy.ErrorAny, (%d,%d)", rowIdx, colIdx);
            otherwise
                error("adx:getRowsWithSchema", "Unexpected NullPolicy: %s", nullPolicy);
        end
    elseif curElement.isJsonArray
        error("adx:getRowsWithSchema", "JSON array not expect for an int64 value, (%d,%d)", rowIdx, colIdx);
    elseif curElement.isJsonObject
        error("adx:getRowsWithSchema", "JSON object not expect for an int64 value, (%d,%d)", rowIdx, colIdx);
    else
        error("adx:getRowsWithSchema", "Unexpected JSON element value, (%d,%d)", rowIdx, colIdx);
    end
end


function val = convert2Double(curElement, nullPolicy, rowIdx, colIdx)
    if curElement.isJsonPrimitive
        val = curElement.getAsDouble();
    elseif curElement.isJsonNull
        switch nullPolicy
            case {mathworks.adx.NullPolicy.ErrorLogicalInt32Int64, mathworks.adx.NullPolicy.AllowAll, mathworks.adx.NullPolicy.Convert2Double}
                val = NaN;
            case mathworks.adx.NullPolicy.ErrorAny
                error("adx:getRowsWithSchema", "Null values are not supported when using: mathworks.adx.NullPolicy.ErrorAny, (%d,%d)", rowIdx, colIdx);
            otherwise
                error("adx:getRowsWithSchema", "Unexpected NullPolicy: %s", nullPolicy);
        end
    elseif curElement.isJsonArray
        error("adx:getRowsWithSchema", "JSON array not expect for a double value, (%d,%d)", rowIdx, colIdx);
    elseif curElement.isJsonObject
        error("adx:getRowsWithSchema", "JSON object not expect for a double value, (%d,%d)", rowIdx, colIdx);
    else
        error("adx:getRowsWithSchema", "Unexpected JSON element value, (%d,%d)", rowIdx, colIdx);
    end
end


function val = convert2String(curElement, kustoSchema, nullPolicy, allowNullStrings, rowIdx, colIdx)
    if curElement.isJsonPrimitive
        val = char(curElement.getAsString);
    elseif curElement.isJsonNull
        if strcmpi(kustoSchema, "guid")
            switch nullPolicy
                case {mathworks.adx.NullPolicy.ErrorLogicalInt32Int64, mathworks.adx.NullPolicy.AllowAll, mathworks.adx.NullPolicy.Convert2Double}
                    val = missing;
                case mathworks.adx.NullPolicy.ErrorAny
                    error("adx:getRowsWithSchema", "Null values are not supported when using: mathworks.adx.NullPolicy.ErrorAny, (%d,%d)", rowIdx, colIdx);
                otherwise
                    error("adx:getRowsWithSchema", "Unexpected NullPolicy: %s", nullPolicy);
            end
        else
            if allowNullStrings
                switch nullPolicy
                    case {mathworks.adx.NullPolicy.ErrorLogicalInt32Int64, mathworks.adx.NullPolicy.AllowAll, mathworks.adx.NullPolicy.Convert2Double}
                        val = "";
                    case mathworks.adx.NullPolicy.ErrorAny
                        error("adx:getRowsWithSchema", "Null values are not supported when using: mathworks.adx.NullPolicy.ErrorAny, (%d,%d)", rowIdx, colIdx);
                    otherwise
                        error("adx:getRowsWithSchema", "Unexpected NullPolicy: %s", nullPolicy);
                end
            else
                % Should not get here
                warning("adx:getRowsWithSchema", 'ADX does not support null strings, allowNullStrings is false, null policy is not applied, returning: ""');
                val = "";
            end
        end
    elseif curElement.isJsonArray
        error("adx:getRowsWithSchema", "JSON array not expect for a string value, (%d,%d)", rowIdx, colIdx);
    elseif curElement.isJsonObject
        error("adx:getRowsWithSchema", "JSON object not expect for a string value, (%d,%d)", rowIdx, colIdx);
    else
        error("adx:getRowsWithSchema", "Unexpected JSON element value, (%d,%d)", rowIdx, colIdx);
    end
end


function val = convert2Datetime(curElement, nullPolicy, rowIdx, colIdx)
    if curElement.isJsonPrimitive
        val = convertString2Datetime(string(curElement.getAsString()));
    elseif curElement.isJsonNull
        switch nullPolicy
            case {mathworks.adx.NullPolicy.ErrorLogicalInt32Int64, mathworks.adx.NullPolicy.AllowAll, mathworks.adx.NullPolicy.Convert2Double}
                val = datetime(NaT, "TimeZone", "UTC");
            case mathworks.adx.NullPolicy.ErrorAny
                error("adx:getRowsWithSchema", "Null values are not supported when using: mathworks.adx.NullPolicy.ErrorAny, (%d,%d)", rowIdx, colIdx);
            otherwise
                error("adx:getRowsWithSchema", "Unexpected NullPolicy: %s", nullPolicy);
        end
    elseif curElement.isJsonArray
        error("adx:getRowsWithSchema", "JSON array not expect for a datetime value, (%d,%d)", rowIdx, colIdx);
    elseif curElement.isJsonObject
        error("adx:getRowsWithSchema", "JSON object not expect for a datetime value, (%d,%d)", rowIdx, colIdx);
    else
        error("adx:getRowsWithSchema", "Unexpected JSON element value, (%d,%d)", rowIdx, colIdx);
    end
end


function val = convert2Duration(curElement, nullPolicy, rowIdx, colIdx)
    if curElement.isJsonPrimitive
        val = mathworks.internal.adx.timespanValue2duration(string(curElement.getAsString()));
    elseif curElement.isJsonNull
        switch nullPolicy
            case {mathworks.adx.NullPolicy.ErrorLogicalInt32Int64, mathworks.adx.NullPolicy.AllowAll, mathworks.adx.NullPolicy.Convert2Double}
                val = NaN;
            case mathworks.adx.NullPolicy.ErrorAny
                error("adx:getRowsWithSchema", "Null values are not supported when using: mathworks.adx.NullPolicy.ErrorAny, (%d,%d)", rowIdx, colIdx);
            otherwise
                error("adx:getRowsWithSchema", "Unexpected NullPolicy: %s", nullPolicy);
        end
    elseif curElement.isJsonArray
        error("adx:getRowsWithSchema", "JSON array not expect for a duration value, (%d,%d)", rowIdx, colIdx);
    elseif curElement.isJsonObject
        error("adx:getRowsWithSchema", "JSON object not expect for a duration value, (%d,%d)", rowIdx, colIdx);
    else
        error("adx:getRowsWithSchema", "Unexpected JSON element value, (%d,%d)", rowIdx, colIdx);
    end
end


function d = convertString2Datetime(dStr)
    arguments
        dStr string {mustBeNonzeroLengthText, mustBeTextScalar}
    end

    % Match '0001-01-01T00:00:00Z'
    baseP = digitsPattern(4) + "-" + digitsPattern(2) + "-" + digitsPattern(2) + "T" + digitsPattern(2) + ":" + digitsPattern(2) + ":" + digitsPattern(2);
    secondPrescisionP = baseP + "Z";
    % Match '2023-01-06T14:36:22.4651963Z'
    subSecondPrescisionP = baseP + "." + digitsPattern + "Z";

    if matches(dStr, secondPrescisionP)
        d = datetime(dStr, "InputFormat", 'yyyy-MM-dd''T''HH:mm:ssZ', "TimeZone", "UTC");
    elseif matches(dStr, subSecondPrescisionP)
        dFields = split(dStr, ".");
        numS = strlength(dFields(end)) - 1; % -1 to remove the Z
        infmt = "yyyy-MM-dd'T'HH:mm:ss." + string(repmat('S', 1, numS)) + "Z";
        d = datetime(dStr, "InputFormat", infmt, "TimeZone", "UTC");
    else
        error("adx:getRowsWithSchema:convertString2Datetime", "Unexpected datetime format: %s", dStr);
    end
end