classdef ManagedPrivateEndpointListResult < adx.control.JSONMapper
% ManagedPrivateEndpointListResult The list managed private endpoints operation response.
% 
% ManagedPrivateEndpointListResult Properties:
%   value - The list of managed private endpoints. - type: array of ManagedPrivateEndpoint

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % value - The list of managed private endpoints. - type: array of ManagedPrivateEndpoint
        value adx.control.models.ManagedPrivateEndpoint { adx.control.JSONMapper.fieldName(value,"value"), adx.control.JSONMapper.JSONArray }
    end

    % Class methods
    methods
        % Constructor
        function obj = ManagedPrivateEndpointListResult(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.ManagedPrivateEndpointListResult
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

