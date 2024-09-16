classdef DataSetHeader < adx.control.JSONMapper
% DataSetHeader Header field of a v2 response

% Copyright 2023-2024 The MathWorks, Inc.

    % Class properties
    properties
        Version string
        IsProgressive logical
    end

    % Class methods
    methods
        % Constructor
        function obj = DataSetHeader(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.data.models.DataSetHeader
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end