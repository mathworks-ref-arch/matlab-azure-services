function outType = mapTypesKustoToMATLAB(inType)
    % MAPTYPESKUSTOTOMATLAB Map Kusto datatypes to corresponding MATLAB type
    % See: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/scalar-data-types/
    % for .net mapping

    % Copyright 2023 The MathWorks, Inc.

    arguments
        inType string {mustBeNonzeroLengthText, mustBeTextScalar}
    end

    switch lower(inType)
        case 'int'
            outType = 'int32';

        case 'long'
            outType = 'int64';

        case 'string'
            outType = 'string';

        case 'guid'
            outType = 'string';

        case 'real'
            outType = 'double';

        case 'datetime'
            outType = 'datetime';

        case 'dynamic'  % Generally JSON
            outType = 'cell';

        case 'bool'
            outType = 'logical';

        case 'timespan'
            outType = 'duration';

        case 'decimal'
            outType = 'double';

        otherwise
            warning("adx:mapTypesKustoToMATLAB","Unexpected type found: %s, defaulting to conversion to a string if possible", inType);
            outType = 'string';
    end
end