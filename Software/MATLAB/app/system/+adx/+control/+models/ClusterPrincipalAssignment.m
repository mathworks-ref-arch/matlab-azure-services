classdef ClusterPrincipalAssignment < adx.control.JSONMapper
% ClusterPrincipalAssignment Class representing a cluster principal assignment.
% 
% ClusterPrincipalAssignment Properties:
%   xproperties - type: ClusterPrincipalProperties_1
%   id - Fully qualified resource ID for the resource. Ex - /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName} - type: string
%   name - The name of the resource - type: string
%   type - The type of the resource. E.g. \"Microsoft.Compute/virtualMachines\" or \"Microsoft.Storage/storageAccounts\" - type: string

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % xproperties - type: ClusterPrincipalProperties_1
        xproperties adx.control.models.ClusterPrincipalProperties_1 { adx.control.JSONMapper.fieldName(xproperties,"properties") }
        % id - Fully qualified resource ID for the resource. Ex - /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName} - type: string
        id string { adx.control.JSONMapper.fieldName(id,"id") }
        % name - The name of the resource - type: string
        name string { adx.control.JSONMapper.fieldName(name,"name") }
        % type - The type of the resource. E.g. \"Microsoft.Compute/virtualMachines\" or \"Microsoft.Storage/storageAccounts\" - type: string
        type string { adx.control.JSONMapper.fieldName(type,"type") }
    end

    % Class methods
    methods
        % Constructor
        function obj = ClusterPrincipalAssignment(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.ClusterPrincipalAssignment
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

