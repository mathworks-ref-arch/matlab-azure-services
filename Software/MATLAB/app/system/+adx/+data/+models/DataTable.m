classdef DataTable < adx.control.JSONMapper
    % DataTable Represents a v1 API format table

    % Copyright 2023 The MathWorks, Inc.

    % Class properties
    properties
        TableId double
        TableKind adx.data.models.TableKind
        TableName string
        Columns adx.data.models.Column {adx.control.JSONMapper.JSONArray}
        Rows {adx.control.JSONMapper.JSONArray, adx.control.JSONMapper.fieldName(Rows,"Rows")}
    end

    % Class methods
    methods
        % Constructor
        function obj = DataTable(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.data.models.DataTable
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end