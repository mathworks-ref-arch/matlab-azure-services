function tf = isMappableMATLABToKusto(matlabType, kustoType, options)
    % isMappableMATLABToKusto Returns true if a MATLAB type can be converted to a given Kusto type
    %
    % The following mappings are supported:
    %
    %  Kusto Type   MATLAB Types
    %  ----------------------------------------------------
    %  int          int8, uint8, int16, uint16, int32
    %  long         int8, uint8, int16, uint16, int32, uint32, int64
    %  string       string char
    %  guid         string char
    %  real         double single
    %  decimal      double single
    %  datetime     datetime
    %  bool         logical
    %  timespan     duration
    %  dynamic      See optional allowDynamic flag
    %
    % As dynamic datatype are "dynamic" the contents must be parsed to determine
    % if the can be converted the optional named argument allowDynamic if true
    % makes the assumption that a dynamic type will be convertible.
    % The default value is true. False is a more conservative value.

    arguments
        matlabType string {mustBeNonzeroLengthText, mustBeTextScalar}
        kustoType string {mustBeNonzeroLengthText, mustBeTextScalar}
        options.allowDynamic (1,1) logical = true
    end

    matlabType =  lower(matlabType);

    switch lower(kustoType)
        case "int"
            tf = any(matches(["int8", "uint8", "int16", "uint16", "int32"], matlabType));

        case "long"
            tf = any(matches(["int8", "uint8", "int16", "uint16", "int32", "uint32", "int64"], matlabType));

        case {"string", "guid"}
            tf = any(matches(["string", "char"], matlabType));

        case {"real", "decimal"}
            tf = any(matches(["double", "single"], matlabType));
    
        case "datetime"
            tf = strcmp("datetime", matlabType);
    
        case "bool"
            tf = strcmp("logical", matlabType);

        case "timespan"
            tf = strcmp("duration", matlabType);
        
        case "dynamic"  % Generally JSON
            tf = options.allowDynamic;

        otherwise
            warning("adx:isMappableMATLABToKusto","Unexpected type found: %s, defaulting to conversion to a string if possible", kustoType);
            tf = false;
    end
end