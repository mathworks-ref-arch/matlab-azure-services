classdef PrivateLinkResourceProperties < adx.control.JSONMapper
% PrivateLinkResourceProperties Properties of a private link resource.
% 
% PrivateLinkResourceProperties Properties:
%   groupId - The private link resource group id. - type: string
%   requiredMembers - The private link resource required member names. - type: array of string
%   requiredZoneNames - The private link resource required zone names. - type: array of string

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % groupId - The private link resource group id. - type: string
        groupId string { adx.control.JSONMapper.fieldName(groupId,"groupId") }
        % requiredMembers - The private link resource required member names. - type: array of string
        requiredMembers string { adx.control.JSONMapper.fieldName(requiredMembers,"requiredMembers"), adx.control.JSONMapper.JSONArray }
        % requiredZoneNames - The private link resource required zone names. - type: array of string
        requiredZoneNames string { adx.control.JSONMapper.fieldName(requiredZoneNames,"requiredZoneNames"), adx.control.JSONMapper.JSONArray }
    end

    % Class methods
    methods
        % Constructor
        function obj = PrivateLinkResourceProperties(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.PrivateLinkResourceProperties
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

