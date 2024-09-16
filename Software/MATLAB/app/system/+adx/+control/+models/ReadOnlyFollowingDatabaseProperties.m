classdef ReadOnlyFollowingDatabaseProperties < adx.control.JSONMapper
% ReadOnlyFollowingDatabaseProperties Class representing the Kusto database properties.
% 
% ReadOnlyFollowingDatabaseProperties Properties:
%   provisioningState - type: ProvisioningState
%   softDeletePeriod - The time the data should be kept before it stops being accessible to queries in TimeSpan. - type: string
%   hotCachePeriod - The time the data should be kept in cache for fast queries in TimeSpan. - type: string
%   statistics - type: DatabaseStatistics
%   leaderClusterResourceId - The name of the leader cluster - type: string
%   attachedDatabaseConfigurationName - The name of the attached database configuration cluster - type: string
%   principalsModificationKind - The principals modification kind of the database - type: string
%   tableLevelSharingProperties - type: TableLevelSharingProperties
%   originalDatabaseName - The original database name, before databaseNameOverride or databaseNamePrefix where applied. - type: string
%   databaseShareOrigin - type: DatabaseShareOrigin
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
        % leaderClusterResourceId - The name of the leader cluster - type: string
        leaderClusterResourceId string { adx.control.JSONMapper.fieldName(leaderClusterResourceId,"leaderClusterResourceId") }
        % attachedDatabaseConfigurationName - The name of the attached database configuration cluster - type: string
        attachedDatabaseConfigurationName string { adx.control.JSONMapper.fieldName(attachedDatabaseConfigurationName,"attachedDatabaseConfigurationName") }
        % principalsModificationKind - The principals modification kind of the database - type: string
        principalsModificationKind adx.control.models.ReadOnlyFollowingDatabaseProPrincipalsModificationKindEnum_0000 { adx.control.JSONMapper.fieldName(principalsModificationKind,"principalsModificationKind") }
        % tableLevelSharingProperties - type: TableLevelSharingProperties
        tableLevelSharingProperties  { adx.control.JSONMapper.fieldName(tableLevelSharingProperties,"tableLevelSharingProperties") }
        % originalDatabaseName - The original database name, before databaseNameOverride or databaseNamePrefix where applied. - type: string
        originalDatabaseName string { adx.control.JSONMapper.fieldName(originalDatabaseName,"originalDatabaseName") }
        % databaseShareOrigin - type: DatabaseShareOrigin
        databaseShareOrigin adx.control.models.DatabaseShareOrigin { adx.control.JSONMapper.fieldName(databaseShareOrigin,"databaseShareOrigin") }
        % suspensionDetails - type: SuspensionDetails
        suspensionDetails  { adx.control.JSONMapper.fieldName(suspensionDetails,"suspensionDetails") }
    end

    % Class methods
    methods
        % Constructor
        function obj = ReadOnlyFollowingDatabaseProperties(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.ReadOnlyFollowingDatabaseProperties
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class
