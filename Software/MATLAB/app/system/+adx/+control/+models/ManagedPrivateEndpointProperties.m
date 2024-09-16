classdef ManagedPrivateEndpointProperties < adx.control.JSONMapper
% ManagedPrivateEndpointProperties A class representing the properties of a managed private endpoint object.
% 
% ManagedPrivateEndpointProperties Properties:
%   privateLinkResourceId - The ARM resource ID of the resource for which the managed private endpoint is created. - type: string
%   privateLinkResourceRegion - The region of the resource to which the managed private endpoint is created. - type: string
%   groupId - The groupId in which the managed private endpoint is created. - type: string
%   requestMessage - The user request message. - type: string
%   provisioningState - type: ProvisioningState

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % privateLinkResourceId - The ARM resource ID of the resource for which the managed private endpoint is created. - type: string
        privateLinkResourceId string { adx.control.JSONMapper.fieldName(privateLinkResourceId,"privateLinkResourceId") }
        % privateLinkResourceRegion - The region of the resource to which the managed private endpoint is created. - type: string
        privateLinkResourceRegion string { adx.control.JSONMapper.fieldName(privateLinkResourceRegion,"privateLinkResourceRegion") }
        % groupId - The groupId in which the managed private endpoint is created. - type: string
        groupId string { adx.control.JSONMapper.fieldName(groupId,"groupId") }
        % requestMessage - The user request message. - type: string
        requestMessage string { adx.control.JSONMapper.fieldName(requestMessage,"requestMessage") }
        % provisioningState - type: ProvisioningState
        provisioningState adx.control.models.ProvisioningState { adx.control.JSONMapper.fieldName(provisioningState,"provisioningState") }
    end

    % Class methods
    methods
        % Constructor
        function obj = ManagedPrivateEndpointProperties(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.ManagedPrivateEndpointProperties
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

