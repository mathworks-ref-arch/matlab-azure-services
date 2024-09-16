classdef QueueIngestionMessage < adx.control.JSONMapper
    % QueueIngestionMessage The message that the Kusto Data Management service expects to read from the input Azure Queue is a JSON document in the following format

    % Copyright 2023 The MathWorks, Inc.

    % Class properties
    properties
        % Message identifier (GUID) <ID>
        Id string
        % Path (URI) to the blob, including the SAS key granting permissions to read/write/delete it.
        % Permissions are required so that the ingestion service can delete the blob once it has completed ingesting the data.
        % https://<AccountName>.blob.core.windows.net/<ContainerName>/<PathToBlob>?<SasToken>
        BlobPath string
        % Size of the uncompressed data in bytes. Providing this value allows the ingestion
        % service to optimize ingestion by potentially aggregating multiple blobs.
        % This property is optional, but if not given, the service will access the blob just to retrieve the size.
        RawDataSize int64
        % Target database name
        DatabaseName string
        % Target table name
        TableName string
        % If set to true, the blob won't be deleted once ingestion is successfully completed. Default is false.
        RetainBlobOnSuccess logical = false
        % If set to true, any aggregation will be skipped. Default is false
        FlushImmediately logical = false
        % Success/Error reporting level: 0-Failures, 1-None, 2-All
        ReportLevel int32
        % Reporting mechanism: 0-Queue, 1-Table
        ReportMethod int32
        % Other properties such as format, tags, and creationTime. For more information, see data ingestion properties.
        AdditionalProperties adx.control.JSONMapperMap
    end

    % Class methods
    methods
        % Constructor
        function obj = QueueIngestionMessage(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.data.models.QueueIngestionMessage
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end