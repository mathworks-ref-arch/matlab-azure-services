classdef OutboundNetworkDependenciesEndpointListResult < adx.control.JSONMapper
% OutboundNetworkDependenciesEndpointListResult Collection of Outbound Environment Endpoints
% 
% OutboundNetworkDependenciesEndpointListResult Properties:
%   value - Collection of resources. - type: array of OutboundNetworkDependenciesEndpoint
%   nextLink - Link to next page of resources. - type: string

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % value - Collection of resources. - type: array of OutboundNetworkDependenciesEndpoint
        value adx.control.models.OutboundNetworkDependenciesEndpoint { adx.control.JSONMapper.fieldName(value,"value"), adx.control.JSONMapper.JSONArray }
        % nextLink - Link to next page of resources. - type: string
        nextLink string { adx.control.JSONMapper.fieldName(nextLink,"nextLink") }
    end

    % Class methods
    methods
        % Constructor
        function obj = OutboundNetworkDependenciesEndpointListResult(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.OutboundNetworkDependenciesEndpointListResult
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

