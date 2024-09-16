classdef ClientRequestProperties < adx.control.JSONMapper
% ClientRequestProperties Adds ClientRequestPropertiesOptions to a query
% See: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/queryparametersstatement

% Copyright 2023 The MathWorks, Inc.

    % Class properties
    properties
        Options adx.data.models.ClientRequestPropertiesOptions
        Parameters adx.data.models.QueryParameter
    end

    % Class methods
    methods
        % Constructor
        function obj = ClientRequestProperties(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.data.models.ClientRequestProperties
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end
