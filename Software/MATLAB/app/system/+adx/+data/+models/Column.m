classdef Column < adx.control.JSONMapper
% Column Represents a Column in a v2 API response

% Copyright 2023 The MathWorks, Inc.

    % Class properties
    properties
        ColumnName string
        ColumnType string
    end

    % Class methods
    methods
        % Constructor
        function obj = Column(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.data.models.Column
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end