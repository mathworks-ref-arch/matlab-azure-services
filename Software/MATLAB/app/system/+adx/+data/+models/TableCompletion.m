classdef TableCompletion < adx.control.JSONMapper
% TableCompletion Field to indicate the end of a table

% Copyright 2023 The MathWorks, Inc.

    % Class properties
    properties
        TableId double
        RowCount double
    end

    % Class methods
    methods
        % Constructor
        function obj = TableCompletion(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.data.models.TableCompletion
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end