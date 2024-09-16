classdef JSONPropertyInfo < handle
    % JSONPROPERTYINFO class used by adx.control.JSONMapper internally

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        mName string
        jName string
        dataType meta.class
        isArray logical
        doNotParse logical
        dtConversionFunction function_handle
        durConversionFunction function_handle
    end


    methods (Access=private)
    end

    methods (Static)
        function props = getPropertyInfo(obj)
            % For all public properties
            ps = properties(obj);
            N = length(ps);
            props = adx.control.JSONPropertyInfo.empty(N,0);
            for i = 1:N
                pm = findprop(obj,ps{i});
                % Set basic properties like the MATLAB name and class
                props(i).mName = pm.Name;
                if ~isempty(pm.Validation)
                    props(i).dataType = pm.Validation.Class;
                else
                    error("Property valuation class not found for: %s, properties must have a type", pm.Name);
                end
                % If class was not set (to allow freeform object properties)
                % still set a specific dataType to allow fromJSON to parse this
                % into a struct using standard jsondecode.
                if isempty(props(i).dataType)
                    % meta-ception
                    props(i).dataType = ?meta.class;
                end
                % Check the "attributes" for further settings
                attrs = cellfun(@(x)functions(x).function,pm.Validation.ValidatorFunctions,'UniformOutput',false);
                if isempty(attrs) % If there are no attributes
                    % Names are the same
                    props(i).jName = pm.Name;
                    % It is not an array
                    props(i).isArray = false;
                    % Throw an error if data type is datetime because this
                    % should have had a dtConversionFunction
                    if props(i).dataType == ?datetime
                        error('JSONMapper:InvalidDatetimeProperty', ...
                            'Property %s is defined as `datetime` but does not have a valid conversion function.',pm.Name);
                    end
                    if props(i).dataType == ?duration
                        error('JSONMapper:InvalidDurationProperty', ...
                            'Property %s is defined as `duration` but does not have a valid conversion function.',pm.Name);
                    end
                else
                    % If datetime, the first "attribute" must be the type definition
                    if props(i).dataType == ?datetime
                        props(i).dtConversionFunction = pm.Validation.ValidatorFunctions{1};
                    end
                    % If datetime, the first "attribute" must be the type definition
                    if props(i).dataType == ?duration
                        props(i).durConversionFunction = pm.Validation.ValidatorFunctions{1};
                    end
                    % Check for JSONArray attribute
                    props(i).isArray = any(strcmp(attrs,'adx.control.JSONMapper.JSONArray'));
                    % Check for fieldName attribute
                    fi = find(contains(attrs,"adx.control.JSONMapper.fieldName"));
                    if isempty(fi) 
                        % If there is none JSON name is same as MATLAB
                        props(i).jName = pm.Name;
                    else
                        % If there is one, call it to obtain the JSON name
                        fieldNameFcn = pm.Validation.ValidatorFunctions{fi};
                        props(i).jName = feval(fieldNameFcn,[]);
                    end
                    props(i).doNotParse = any(strcmp(attrs,'adx.control.JSONMapper.doNotParse'));
                end
            end
        end
    end
end