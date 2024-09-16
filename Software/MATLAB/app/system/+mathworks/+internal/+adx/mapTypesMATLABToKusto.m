function outType = mapTypesMATLABToKusto(inType)
    % mapTypesMATLABToKusto Map MATLAB datatypes to corresponding Kusto type
    % See: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/scalar-data-types/
    % for .net mapping

    % Copyright 2023 The MathWorks, Inc.

    arguments
        inType string {mustBeNonzeroLengthText, mustBeTextScalar}
    end

    switch lower(inType)
        case 'int32'
            outType = 'int';

        case 'int64'
            outType = 'long';

        case 'string'
            outType = 'string';

        case 'double'
            outType = 'real';

        case 'datetime'
            outType = 'datetime';

        case 'duration'
            outType = 'timespan';

        case 'logical'
            outType = 'bool';

        otherwise
            warning("adx:mapTypesMATLABToKusto","Unexpected type found: %s, defaulting to conversion to a string if possible", inType);
            outType = 'string';
    end
end