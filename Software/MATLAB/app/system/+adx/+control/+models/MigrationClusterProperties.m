classdef MigrationClusterProperties < adx.control.JSONMapper
% MigrationClusterProperties Represents a properties of a cluster that is part of a migration.
% 
% MigrationClusterProperties Properties:
%   id - The resource ID of the cluster. - type: string
%   uri - The public URL of the cluster. - type: string
%   dataIngestionUri - The public data ingestion URL of the cluster. - type: string
%   role - The role of the cluster in the migration process. - type: string

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % id - The resource ID of the cluster. - type: string
        id string { adx.control.JSONMapper.fieldName(id,"id") }
        % uri - The public URL of the cluster. - type: string
        uri string { adx.control.JSONMapper.fieldName(uri,"uri") }
        % dataIngestionUri - The public data ingestion URL of the cluster. - type: string
        dataIngestionUri string { adx.control.JSONMapper.fieldName(dataIngestionUri,"dataIngestionUri") }
        % role - The role of the cluster in the migration process. - type: string
        role adx.control.models.MigrationClusterPropertiesRoleEnum { adx.control.JSONMapper.fieldName(role,"role") }
    end

    % Class methods
    methods
        % Constructor
        function obj = MigrationClusterProperties(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.MigrationClusterProperties
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

