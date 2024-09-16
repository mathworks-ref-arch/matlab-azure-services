classdef TableProgress < adx.control.JSONMapper
% TableProgress Indicates the percentage of a task task that is complete

% Copyright 2023 The MathWorks, Inc.

    % Class properties
    properties
        TableId double
        TableProgressProp double
    end

    % Class methods
    methods
        % Constructor
        function obj = TableProgress(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.data.models.TableProgress
             end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end