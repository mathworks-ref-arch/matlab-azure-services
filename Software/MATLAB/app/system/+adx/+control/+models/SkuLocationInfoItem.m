classdef SkuLocationInfoItem < adx.control.JSONMapper
% SkuLocationInfoItem The locations and zones info for SKU.
% 
% SkuLocationInfoItem Properties:
%   location - The available location of the SKU. - type: string
%   zones - The available zone of the SKU. - type: array of string
%   zoneDetails - Gets details of capabilities available to a SKU in specific zones. - type: array of ResourceSkuZoneDetails

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % location - The available location of the SKU. - type: string
        location string { adx.control.JSONMapper.fieldName(location,"location") }
        % zones - The available zone of the SKU. - type: array of string
        zones string { adx.control.JSONMapper.fieldName(zones,"zones"), adx.control.JSONMapper.JSONArray }
        % zoneDetails - Gets details of capabilities available to a SKU in specific zones. - type: array of ResourceSkuZoneDetails
        zoneDetails adx.control.models.ResourceSkuZoneDetails { adx.control.JSONMapper.fieldName(zoneDetails,"zoneDetails"), adx.control.JSONMapper.JSONArray }
    end

    % Class methods
    methods
        % Constructor
        function obj = SkuLocationInfoItem(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.SkuLocationInfoItem
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

