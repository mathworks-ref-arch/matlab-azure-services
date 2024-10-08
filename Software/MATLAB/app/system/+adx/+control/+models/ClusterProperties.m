classdef ClusterProperties < adx.control.JSONMapper
% ClusterProperties Class representing the Kusto cluster properties.
% 
% ClusterProperties Properties:
%   state - The state of the resource. - type: string
%   provisioningState - type: ProvisioningState
%   uri - The cluster URI. - type: string
%   dataIngestionUri - The cluster data ingestion URI. - type: string
%   stateReason - The reason for the cluster''s current state. - type: string
%   trustedExternalTenants - The cluster''s external tenants. - type: array of TrustedExternalTenant
%   optimizedAutoscale - type: OptimizedAutoscale
%   enableDiskEncryption - A boolean value that indicates if the cluster''s disks are encrypted. - type: logical
%   enableStreamingIngest - A boolean value that indicates if the streaming ingest is enabled. - type: logical
%   virtualNetworkConfiguration - type: VirtualNetworkConfiguration
%   keyVaultProperties - type: KeyVaultProperties
%   enablePurge - A boolean value that indicates if the purge operations are enabled. - type: logical
%   languageExtensions - type: LanguageExtensionsList
%   enableDoubleEncryption - A boolean value that indicates if double encryption is enabled. - type: logical
%   publicNetworkAccess - Public network access to the cluster is enabled by default. When disabled, only private endpoint connection to the cluster is allowed - type: string
%   allowedIpRangeList - The list of ips in the format of CIDR allowed to connect to the cluster. - type: array of string
%   engineType - The engine type - type: string
%   acceptedAudiences - The cluster''s accepted audiences. - type: array of AcceptedAudiences
%   enableAutoStop - A boolean value that indicates if the cluster could be automatically stopped (due to lack of data or no activity for many days). - type: logical
%   restrictOutboundNetworkAccess - Whether or not to restrict outbound network access.  Value is optional but if passed in, must be ''Enabled'' or ''Disabled'' - type: string
%   allowedFqdnList - List of allowed FQDNs(Fully Qualified Domain Name) for egress from Cluster. - type: array of string
%   publicIPType - Indicates what public IP type to create - IPv4 (default), or DualStack (both IPv4 and IPv6) - type: string
%   virtualClusterGraduationProperties - Virtual Cluster graduation properties - type: string
%   privateEndpointConnections - A list of private endpoint connections. - type: array of PrivateEndpointConnection
%   migrationCluster - type: MigrationClusterProperties

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % state - The state of the resource. - type: string
        state adx.control.models.ClusterPropertiesStateEnum { adx.control.JSONMapper.fieldName(state,"state") }
        % provisioningState - type: ProvisioningState
        provisioningState adx.control.models.ProvisioningState { adx.control.JSONMapper.fieldName(provisioningState,"provisioningState") }
        % uri - The cluster URI. - type: string
        uri string { adx.control.JSONMapper.fieldName(uri,"uri") }
        % dataIngestionUri - The cluster data ingestion URI. - type: string
        dataIngestionUri string { adx.control.JSONMapper.fieldName(dataIngestionUri,"dataIngestionUri") }
        % stateReason - The reason for the cluster''s current state. - type: string
        stateReason string { adx.control.JSONMapper.fieldName(stateReason,"stateReason") }
        % trustedExternalTenants - The cluster''s external tenants. - type: array of TrustedExternalTenant
        trustedExternalTenants adx.control.models.TrustedExternalTenant { adx.control.JSONMapper.fieldName(trustedExternalTenants,"trustedExternalTenants"), adx.control.JSONMapper.JSONArray }
        % optimizedAutoscale - type: OptimizedAutoscale
        optimizedAutoscale  { adx.control.JSONMapper.fieldName(optimizedAutoscale,"optimizedAutoscale") }
        % enableDiskEncryption - A boolean value that indicates if the cluster''s disks are encrypted. - type: logical
        enableDiskEncryption logical { adx.control.JSONMapper.fieldName(enableDiskEncryption,"enableDiskEncryption") }
        % enableStreamingIngest - A boolean value that indicates if the streaming ingest is enabled. - type: logical
        enableStreamingIngest logical { adx.control.JSONMapper.fieldName(enableStreamingIngest,"enableStreamingIngest") }
        % virtualNetworkConfiguration - type: VirtualNetworkConfiguration
        virtualNetworkConfiguration  { adx.control.JSONMapper.fieldName(virtualNetworkConfiguration,"virtualNetworkConfiguration") }
        % keyVaultProperties - type: KeyVaultProperties
        keyVaultProperties  { adx.control.JSONMapper.fieldName(keyVaultProperties,"keyVaultProperties") }
        % enablePurge - A boolean value that indicates if the purge operations are enabled. - type: logical
        enablePurge logical { adx.control.JSONMapper.fieldName(enablePurge,"enablePurge") }
        % languageExtensions - type: LanguageExtensionsList
        languageExtensions  { adx.control.JSONMapper.fieldName(languageExtensions,"languageExtensions") }
        % enableDoubleEncryption - A boolean value that indicates if double encryption is enabled. - type: logical
        enableDoubleEncryption logical { adx.control.JSONMapper.fieldName(enableDoubleEncryption,"enableDoubleEncryption") }
        % publicNetworkAccess - Public network access to the cluster is enabled by default. When disabled, only private endpoint connection to the cluster is allowed - type: string
        publicNetworkAccess adx.control.models.ClusterPropertiesPublicNetworkAccessEnum { adx.control.JSONMapper.fieldName(publicNetworkAccess,"publicNetworkAccess") }
        % allowedIpRangeList - The list of ips in the format of CIDR allowed to connect to the cluster. - type: array of string
        allowedIpRangeList string { adx.control.JSONMapper.fieldName(allowedIpRangeList,"allowedIpRangeList"), adx.control.JSONMapper.JSONArray }
        % engineType - The engine type - type: string
        engineType adx.control.models.ClusterPropertiesEngineTypeEnum { adx.control.JSONMapper.fieldName(engineType,"engineType") }
        % acceptedAudiences - The cluster''s accepted audiences. - type: array of AcceptedAudiences
        acceptedAudiences adx.control.models.AcceptedAudiences { adx.control.JSONMapper.fieldName(acceptedAudiences,"acceptedAudiences"), adx.control.JSONMapper.JSONArray }
        % enableAutoStop - A boolean value that indicates if the cluster could be automatically stopped (due to lack of data or no activity for many days). - type: logical
        enableAutoStop logical { adx.control.JSONMapper.fieldName(enableAutoStop,"enableAutoStop") }
        % restrictOutboundNetworkAccess - Whether or not to restrict outbound network access.  Value is optional but if passed in, must be ''Enabled'' or ''Disabled'' - type: string
        restrictOutboundNetworkAccess adx.control.models.ClusterPropertiesRestrictOutboundNetworkAccessEnum { adx.control.JSONMapper.fieldName(restrictOutboundNetworkAccess,"restrictOutboundNetworkAccess") }
        % allowedFqdnList - List of allowed FQDNs(Fully Qualified Domain Name) for egress from Cluster. - type: array of string
        allowedFqdnList string { adx.control.JSONMapper.fieldName(allowedFqdnList,"allowedFqdnList"), adx.control.JSONMapper.JSONArray }
        % publicIPType - Indicates what public IP type to create - IPv4 (default), or DualStack (both IPv4 and IPv6) - type: string
        publicIPType adx.control.models.ClusterPropertiesPublicIPTypeEnum { adx.control.JSONMapper.fieldName(publicIPType,"publicIPType") }
        % virtualClusterGraduationProperties - Virtual Cluster graduation properties - type: string
        virtualClusterGraduationProperties string { adx.control.JSONMapper.fieldName(virtualClusterGraduationProperties,"virtualClusterGraduationProperties") }
        % privateEndpointConnections - A list of private endpoint connections. - type: array of PrivateEndpointConnection
        privateEndpointConnections adx.control.models.PrivateEndpointConnection { adx.control.JSONMapper.fieldName(privateEndpointConnections,"privateEndpointConnections"), adx.control.JSONMapper.JSONArray }
        % migrationCluster - type: MigrationClusterProperties
        migrationCluster  { adx.control.JSONMapper.fieldName(migrationCluster,"migrationCluster") }
    end

    % Class methods
    methods
        % Constructor
        function obj = ClusterProperties(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.ClusterProperties
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

