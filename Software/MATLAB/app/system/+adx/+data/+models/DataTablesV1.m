classdef DataTablesV1 < adx.control.JSONMapper
    % DataTablesV1 Represents an array of v1 API tables
    
    % Copyright 2023 The MathWorks, Inc.

    properties
        Tables adx.data.models.DataTableV1 {adx.control.JSONMapper.JSONArray}
    end

     % Class methods
     methods
        % Constructor
        function obj = DataTablesV1(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.data.models.DataTablesV1
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end