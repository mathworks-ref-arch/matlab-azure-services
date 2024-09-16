classdef EventHubConnectionProperties_1 < adx.control.JSONMapper
% EventHubConnectionProperties_1 Class representing the Kusto event hub connection properties.
% 
% EventHubConnectionProperties_1 Properties:
%   eventHubResourceId - The resource ID of the event hub to be used to create a data connection. - type: string
%   consumerGroup - The event hub consumer group. - type: string
%   tableName - The table where the data should be ingested. Optionally the table information can be added to each message. - type: string
%   mappingRuleName - The mapping rule to be used to ingest the data. Optionally the mapping information can be added to each message. - type: string
%   dataFormat - type: EventHubDataFormat
%   eventSystemProperties - System properties of the event hub - type: array of string
%   compression - type: Compression
%   provisioningState - type: ProvisioningState
%   managedIdentityResourceId - The resource ID of a managed identity (system or user assigned) to be used to authenticate with event hub. - type: string
%   managedIdentityObjectId - The object ID of the managedIdentityResourceId - type: string
%   databaseRouting - Indication for database routing information from the data connection, by default only database routing information is allowed - type: string
%   retrievalStartDate - When defined, the data connection retrieves existing Event hub events created since the Retrieval start date. It can only retrieve events retained by the Event hub, based on its retention period. - type: datetime

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % eventHubResourceId - The resource ID of the event hub to be used to create a data connection. - type: string
        eventHubResourceId string { adx.control.JSONMapper.fieldName(eventHubResourceId,"eventHubResourceId") }
        % consumerGroup - The event hub consumer group. - type: string
        consumerGroup string { adx.control.JSONMapper.fieldName(consumerGroup,"consumerGroup") }
        % tableName - The table where the data should be ingested. Optionally the table information can be added to each message. - type: string
        tableName string { adx.control.JSONMapper.fieldName(tableName,"tableName") }
        % mappingRuleName - The mapping rule to be used to ingest the data. Optionally the mapping information can be added to each message. - type: string
        mappingRuleName string { adx.control.JSONMapper.fieldName(mappingRuleName,"mappingRuleName") }
        % dataFormat - type: EventHubDataFormat
        dataFormat adx.control.models.EventHubDataFormat { adx.control.JSONMapper.fieldName(dataFormat,"dataFormat") }
        % eventSystemProperties - System properties of the event hub - type: array of string
        eventSystemProperties string { adx.control.JSONMapper.fieldName(eventSystemProperties,"eventSystemProperties"), adx.control.JSONMapper.JSONArray }
        % compression - type: Compression
        compression adx.control.models.Compression { adx.control.JSONMapper.fieldName(compression,"compression") }
        % provisioningState - type: ProvisioningState
        provisioningState adx.control.models.ProvisioningState { adx.control.JSONMapper.fieldName(provisioningState,"provisioningState") }
        % managedIdentityResourceId - The resource ID of a managed identity (system or user assigned) to be used to authenticate with event hub. - type: string
        managedIdentityResourceId string { adx.control.JSONMapper.fieldName(managedIdentityResourceId,"managedIdentityResourceId") }
        % managedIdentityObjectId - The object ID of the managedIdentityResourceId - type: string
        managedIdentityObjectId string { adx.control.JSONMapper.fieldName(managedIdentityObjectId,"managedIdentityObjectId") }
        % databaseRouting - Indication for database routing information from the data connection, by default only database routing information is allowed - type: string
        databaseRouting adx.control.models.EventHubConnectionProperties_1DatabaseRoutingEnum { adx.control.JSONMapper.fieldName(databaseRouting,"databaseRouting") }
        % retrievalStartDate - When defined, the data connection retrieves existing Event hub events created since the Retrieval start date. It can only retrieve events retained by the Event hub, based on its retention period. - type: datetime
        retrievalStartDate datetime { adx.control.JSONMapper.stringDatetime(retrievalStartDate,'yyyy-MM-dd''T''HH:mm:ss.SSSZ', 'TimeZone', 'local'), adx.control.JSONMapper.fieldName(retrievalStartDate,"retrievalStartDate") }
    end

    % Class methods
    methods
        % Constructor
        function obj = EventHubConnectionProperties_1(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.EventHubConnectionProperties_1
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class
