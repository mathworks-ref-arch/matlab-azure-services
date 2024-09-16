classdef (Abstract) JSONEnum
    % JSONEnum Base class for enumerations when working with adx.control.JSONMapper
    % When adding enumeration properties to adx.control.JSONMapper objects, the custom
    % enumeration classes must inherit from this JSONEnum base class. And
    % the custom enumeration class must declare string values for each enum
    % element, these represent the JSON representation of the enumeration
    % values; this is required since not all JSON values are guaranteed to
    % be valid MATLAB variable names whereas the actual MATLAB enumeration
    % values must be.
    %
    %   Example:
    %
    %     classdef myEnum < JSONEnum
    %         enumeration
    %             VAL1 ("VAL.1")
    %             VAL2 ("VAL.2")
    %         end
    %     end
    %
    % Even if JSON values are valid MATLAB variables, the string value must
    % be provided, e.g.:
    %
    %     classdef myEnum < JSONEnum
    %         enumeration
    %             VAL1 ("VAL1")
    %             VAL2 ("VAL2")
    %         end
    %     end

    % Copyright 2022 The MathWorks, Inc.

    properties (SetAccess = immutable)
        JSONValue
    end
    methods
        function obj = JSONEnum(value)
            obj.JSONValue = value;
        end
        function v = fromJSON(obj,json)
            vals = enumeration(obj);
            v = vals(strcmp([vals.JSONValue],char(json)));
            if isempty(v)
                error("JSONMapper:JSONEnum:invalid",'String "%s" is not a valid enumeration value for enumeration type "%s"',json,class(obj));
            end
        end
    end
end