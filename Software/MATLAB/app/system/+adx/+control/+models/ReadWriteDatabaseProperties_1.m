classdef ReadWriteDatabaseProperties_1 < adx.control.JSONMapper
% ReadWriteDatabaseProperties_1 Class representing the Kusto database properties.
% 
% ReadWriteDatabaseProperties_1 Properties:
%   provisioningState - type: ProvisioningState
%   softDeletePeriod - The time the data should be kept before it stops being accessible to queries in TimeSpan. - type: string
%   hotCachePeriod - The time the data should be kept in cache for fast queries in TimeSpan. - type: string
%   statistics - type: DatabaseStatistics
%   isFollowed - Indicates whether the database is followed. - type: logical
%   keyVaultProperties - type: KeyVaultProperties
%   suspensionDetails - type: SuspensionDetails

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % provisioningState - type: ProvisioningState
        provisioningState adx.control.models.ProvisioningState { adx.control.JSONMapper.fieldName(provisioningState,"provisioningState") }
        % softDeletePeriod - The time the data should be kept before it stops being accessible to queries in TimeSpan. - type: string
        softDeletePeriod string { adx.control.JSONMapper.fieldName(softDeletePeriod,"softDeletePeriod") }
        % hotCachePeriod - The time the data should be kept in cache for fast queries in TimeSpan. - type: string
        hotCachePeriod string { adx.control.JSONMapper.fieldName(hotCachePeriod,"hotCachePeriod") }
        % statistics - type: DatabaseStatistics
        statistics adx.control.models.DatabaseStatistics { adx.control.JSONMapper.fieldName(statistics,"statistics") }
        % isFollowed - Indicates whether the database is followed. - type: logical
        isFollowed logical { adx.control.JSONMapper.fieldName(isFollowed,"isFollowed") }
        % keyVaultProperties - type: KeyVaultProperties
        keyVaultProperties  { adx.control.JSONMapper.fieldName(keyVaultProperties,"keyVaultProperties") }
        % suspensionDetails - type: SuspensionDetails
        suspensionDetails  { adx.control.JSONMapper.fieldName(suspensionDetails,"suspensionDetails") }
    end

    % Class methods
    methods
        % Constructor
        function obj = ReadWriteDatabaseProperties_1(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.ReadWriteDatabaseProperties_1
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class
