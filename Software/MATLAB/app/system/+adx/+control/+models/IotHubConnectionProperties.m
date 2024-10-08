classdef IotHubConnectionProperties < adx.control.JSONMapper
% IotHubConnectionProperties Class representing the Kusto Iot hub connection properties.
% 
% IotHubConnectionProperties Properties:
%   iotHubResourceId - The resource ID of the Iot hub to be used to create a data connection. - type: string
%   consumerGroup - The iot hub consumer group. - type: string
%   tableName - The table where the data should be ingested. Optionally the table information can be added to each message. - type: string
%   mappingRuleName - The mapping rule to be used to ingest the data. Optionally the mapping information can be added to each message. - type: string
%   dataFormat - type: IotHubDataFormat
%   eventSystemProperties - System properties of the iot hub - type: array of string
%   sharedAccessPolicyName - The name of the share access policy - type: string
%   databaseRouting - Indication for database routing information from the data connection, by default only database routing information is allowed - type: string
%   retrievalStartDate - When defined, the data connection retrieves existing Event hub events created since the Retrieval start date. It can only retrieve events retained by the Event hub, based on its retention period. - type: datetime
%   provisioningState - type: ProvisioningState

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % iotHubResourceId - The resource ID of the Iot hub to be used to create a data connection. - type: string
        iotHubResourceId string { adx.control.JSONMapper.fieldName(iotHubResourceId,"iotHubResourceId") }
        % consumerGroup - The iot hub consumer group. - type: string
        consumerGroup string { adx.control.JSONMapper.fieldName(consumerGroup,"consumerGroup") }
        % tableName - The table where the data should be ingested. Optionally the table information can be added to each message. - type: string
        tableName string { adx.control.JSONMapper.fieldName(tableName,"tableName") }
        % mappingRuleName - The mapping rule to be used to ingest the data. Optionally the mapping information can be added to each message. - type: string
        mappingRuleName string { adx.control.JSONMapper.fieldName(mappingRuleName,"mappingRuleName") }
        % dataFormat - type: IotHubDataFormat
        dataFormat adx.control.models.IotHubDataFormat { adx.control.JSONMapper.fieldName(dataFormat,"dataFormat") }
        % eventSystemProperties - System properties of the iot hub - type: array of string
        eventSystemProperties string { adx.control.JSONMapper.fieldName(eventSystemProperties,"eventSystemProperties"), adx.control.JSONMapper.JSONArray }
        % sharedAccessPolicyName - The name of the share access policy - type: string
        sharedAccessPolicyName string { adx.control.JSONMapper.fieldName(sharedAccessPolicyName,"sharedAccessPolicyName") }
        % databaseRouting - Indication for database routing information from the data connection, by default only database routing information is allowed - type: string
        databaseRouting adx.control.models.IotHubConnectionPropertiesDatabaseRoutingEnum { adx.control.JSONMapper.fieldName(databaseRouting,"databaseRouting") }
        % retrievalStartDate - When defined, the data connection retrieves existing Event hub events created since the Retrieval start date. It can only retrieve events retained by the Event hub, based on its retention period. - type: datetime
        retrievalStartDate datetime { adx.control.JSONMapper.stringDatetime(retrievalStartDate,'yyyy-MM-dd''T''HH:mm:ss.SSSZ', 'TimeZone', 'local'), adx.control.JSONMapper.fieldName(retrievalStartDate,"retrievalStartDate") }
        % provisioningState - type: ProvisioningState
        provisioningState adx.control.models.ProvisioningState { adx.control.JSONMapper.fieldName(provisioningState,"provisioningState") }
    end

    % Class methods
    methods
        % Constructor
        function obj = IotHubConnectionProperties(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.IotHubConnectionProperties
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

