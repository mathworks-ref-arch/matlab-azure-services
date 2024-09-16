classdef ClusterUpdate < adx.control.JSONMapper
% ClusterUpdate Class representing an update to a Kusto cluster.
% 
% ClusterUpdate Properties:
%   tags - Resource tags. - type: adx.control.JSONMapperMap
%   location - Resource location. - type: string
%   sku - type: AzureSku
%   identity - type: Identity
%   xproperties - type: ClusterProperties_1
%   id - Fully qualified resource ID for the resource. Ex - /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName} - type: string
%   name - The name of the resource - type: string
%   type - The type of the resource. E.g. \"Microsoft.Compute/virtualMachines\" or \"Microsoft.Storage/storageAccounts\" - type: string

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % tags - Resource tags. - type: adx.control.JSONMapperMap
        tags adx.control.JSONMapperMap { adx.control.JSONMapper.fieldName(tags,"tags") }
        % location - Resource location. - type: string
        location string { adx.control.JSONMapper.fieldName(location,"location") }
        % sku - type: AzureSku
        sku adx.control.models.AzureSku { adx.control.JSONMapper.fieldName(sku,"sku") }
        % identity - type: Identity
        identity adx.control.models.Identity { adx.control.JSONMapper.fieldName(identity,"identity") }
        % xproperties - type: ClusterProperties_1
        xproperties adx.control.models.ClusterProperties_1 { adx.control.JSONMapper.fieldName(xproperties,"properties") }
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
        function obj = ClusterUpdate(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.ClusterUpdate
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

