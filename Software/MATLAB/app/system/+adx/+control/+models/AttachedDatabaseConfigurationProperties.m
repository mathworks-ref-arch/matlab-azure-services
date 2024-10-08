classdef AttachedDatabaseConfigurationProperties < adx.control.JSONMapper
% AttachedDatabaseConfigurationProperties Class representing the an attached database configuration properties of kind specific.
% 
% AttachedDatabaseConfigurationProperties Properties:
%   provisioningState - type: ProvisioningState
%   databaseName - The name of the database which you would like to attach, use * if you want to follow all current and future databases. - type: string
%   clusterResourceId - The resource id of the cluster where the databases you would like to attach reside. - type: string
%   attachedDatabaseNames - The list of databases from the clusterResourceId which are currently attached to the cluster. - type: array of string
%   defaultPrincipalsModificationKind - The default principals modification kind - type: string
%   tableLevelSharingProperties - type: TableLevelSharingProperties
%   databaseNameOverride - Overrides the original database name. Relevant only when attaching to a specific database. - type: string
%   databaseNamePrefix - Adds a prefix to the attached databases name. When following an entire cluster, that prefix would be added to all of the databases original names from leader cluster. - type: string

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % provisioningState - type: ProvisioningState
        provisioningState adx.control.models.ProvisioningState { adx.control.JSONMapper.fieldName(provisioningState,"provisioningState") }
        % databaseName - The name of the database which you would like to attach, use * if you want to follow all current and future databases. - type: string
        databaseName string { adx.control.JSONMapper.fieldName(databaseName,"databaseName") }
        % clusterResourceId - The resource id of the cluster where the databases you would like to attach reside. - type: string
        clusterResourceId string { adx.control.JSONMapper.fieldName(clusterResourceId,"clusterResourceId") }
        % attachedDatabaseNames - The list of databases from the clusterResourceId which are currently attached to the cluster. - type: array of string
        attachedDatabaseNames string { adx.control.JSONMapper.fieldName(attachedDatabaseNames,"attachedDatabaseNames"), adx.control.JSONMapper.JSONArray }
        % defaultPrincipalsModificationKind - The default principals modification kind - type: string
        defaultPrincipalsModificationKind adx.control.models.AttachedDatabaseConfiDefaultPrincipalsModificationKindEnum_0000 { adx.control.JSONMapper.fieldName(defaultPrincipalsModificationKind,"defaultPrincipalsModificationKind") }
        % tableLevelSharingProperties - type: TableLevelSharingProperties
        tableLevelSharingProperties  { adx.control.JSONMapper.fieldName(tableLevelSharingProperties,"tableLevelSharingProperties") }
        % databaseNameOverride - Overrides the original database name. Relevant only when attaching to a specific database. - type: string
        databaseNameOverride string { adx.control.JSONMapper.fieldName(databaseNameOverride,"databaseNameOverride") }
        % databaseNamePrefix - Adds a prefix to the attached databases name. When following an entire cluster, that prefix would be added to all of the databases original names from leader cluster. - type: string
        databaseNamePrefix string { adx.control.JSONMapper.fieldName(databaseNamePrefix,"databaseNamePrefix") }
    end

    % Class methods
    methods
        % Constructor
        function obj = AttachedDatabaseConfigurationProperties(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.AttachedDatabaseConfigurationProperties
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

