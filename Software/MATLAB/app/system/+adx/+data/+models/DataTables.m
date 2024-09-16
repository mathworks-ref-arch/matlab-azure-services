classdef DataTables < adx.control.JSONMapper
    % DataTables Represents an array of v2 API tables

    % Copyright 2023 The MathWorks, Inc.

    properties
        Tables adx.data.models.DataTable {adx.control.JSONMapper.JSONArray}
    end

     % Class methods
     methods
        % Constructor
        function obj = DataTables(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.data.models.DataTables
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end