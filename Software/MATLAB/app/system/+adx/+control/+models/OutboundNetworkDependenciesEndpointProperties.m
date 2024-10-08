classdef OutboundNetworkDependenciesEndpointProperties < adx.control.JSONMapper
% OutboundNetworkDependenciesEndpointProperties Endpoints accessed for a common purpose that the Kusto Service Environment requires outbound network access to.
% 
% OutboundNetworkDependenciesEndpointProperties Properties:
%   category - The type of service accessed by the Kusto Service Environment, e.g., Azure Storage, Azure SQL Database, and Azure Active Directory. - type: string
%   endpoints - The endpoints that the Kusto Service Environment reaches the service at. - type: array of EndpointDependency
%   provisioningState - type: ProvisioningState

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % category - The type of service accessed by the Kusto Service Environment, e.g., Azure Storage, Azure SQL Database, and Azure Active Directory. - type: string
        category string { adx.control.JSONMapper.fieldName(category,"category") }
        % endpoints - The endpoints that the Kusto Service Environment reaches the service at. - type: array of EndpointDependency
        endpoints adx.control.models.EndpointDependency { adx.control.JSONMapper.fieldName(endpoints,"endpoints"), adx.control.JSONMapper.JSONArray }
        % provisioningState - type: ProvisioningState
        provisioningState adx.control.models.ProvisioningState { adx.control.JSONMapper.fieldName(provisioningState,"provisioningState") }
    end

    % Class methods
    methods
        % Constructor
        function obj = OutboundNetworkDependenciesEndpointProperties(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.OutboundNetworkDependenciesEndpointProperties
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

