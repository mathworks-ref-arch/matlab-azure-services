classdef QueryV1ResponseRaw < adx.control.JSONMapper
    % QueryV1ResponseRaw Represents a v1 API response prior to conversion to a table or error

    % Copyright 2023 The MathWorks, Inc.

    properties
        Tables adx.data.models.DataTableV1 {adx.control.JSONMapper.JSONArray}
    end

     % Class methods
     methods
        % Constructor
        function obj = QueryV1ResponseRaw(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.data.models.QueryV1ResponseRaw
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end