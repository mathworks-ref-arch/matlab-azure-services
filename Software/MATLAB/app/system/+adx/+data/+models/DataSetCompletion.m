classdef DataSetCompletion < adx.control.JSONMapper
% DataSetCompletion Final field of a v2 response

% Copyright 2023 The MathWorks, Inc.

    % Class properties
    properties
        HasErrors logical
        Cancelled logical
        OneApiErrors {adx.control.JSONMapper.JSONArray}
    end

    % Class methods
    methods
        % Constructor
        function obj = DataSetCompletion(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.data.models.DataSetCompletion
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end