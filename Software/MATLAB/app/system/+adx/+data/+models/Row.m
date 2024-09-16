classdef Row < adx.control.JSONMapper
% Row Represents a row that is parsed by JSONMapper
% Class not used pending updated JSONMapper capability to handle simple arrays

% Copyright 2023 The MathWorks, Inc.

    % Class properties
    properties
        RowStr string
    end


    % Class methods
    methods
        % Constructor
        function obj = Row(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.data.models.Row
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end