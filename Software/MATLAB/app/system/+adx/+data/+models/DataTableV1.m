classdef DataTableV1 < adx.control.JSONMapper
% DataTableV1 Represents a v1 API format table

    % Copyright 2023 The MathWorks, Inc.

    % Class properties
    properties
        TableName (1,1) string
        Columns adx.data.models.ColumnV1 {adx.control.JSONMapper.JSONArray}
        Rows string {adx.control.JSONMapper.JSONArray, adx.control.JSONMapper.doNotParse, adx.control.JSONMapper.fieldName(Rows,"Rows")}
    end

    % Class methods
    methods
        % Constructor
        function obj = DataTableV1(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.data.models.DataTableV1
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end