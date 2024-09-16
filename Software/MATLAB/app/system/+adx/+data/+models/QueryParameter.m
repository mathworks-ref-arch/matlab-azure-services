classdef QueryParameter < adx.control.JSONMapper
% QueryParameter Represents Key Value pairs for queries
% See: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/queryparametersstatement

% Copyright 2023 The MathWorks, Inc.

    % Class properties
    properties
        % The name of a query parameter used in the query
        Name string
        % The corresponding type, such as string or datetime
        % The values provided by the user are encoded as strings.
        % The appropriate parse method is applied to the query parameter to get a strongly-typed value.
        Value string
        % A default value for the parameter. This value must be a literal of the appropriate scalar type
        DefaultValue string
    end

    % Class methods
    methods
        % Constructor
        function obj = QueryParameter(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.data.models.QueryParameter
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end