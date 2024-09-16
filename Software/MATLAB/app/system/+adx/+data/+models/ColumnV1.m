classdef ColumnV1 < adx.control.JSONMapper
% ColumnV1 Represents a Column in a v1 API response

% Copyright 2023 The MathWorks, Inc.

    % Class properties
    properties
        ColumnName string
        DataType string
        ColumnType string
    end

    % Class methods
    methods
        % Constructor
        function obj = ColumnV1(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.data.models.ColumnV1
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end