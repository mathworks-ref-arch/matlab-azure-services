classdef BlobLeaseClientBuilder < azure.object
% BLOBCLIENTBUILDER This class provides a fluent builder API to help aid
% the configuration and instantiation of Storage Lease clients.

% Copyright 2022 The MathWorks, Inc.

    properties
    end
    
    methods
        function obj = BlobLeaseClientBuilder(varargin)
            initialize('loggerPrefix', 'Azure:ADLSG2');

            if nargin == 0
                obj.Handle = com.azure.storage.blob.specialized.BlobLeaseClientBuilder();
            elseif nargin == 1 && isa(varargin{1}, 'com.azure.storage.blob.specialized.BlobLeaseClientBuilder')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid argument(s)');
            end
        end

        function builder = blobClient(builder, client)
            % BLOBCLIENT Configures the builder based on the passed
            % BlobClient. This will set the HttpPipeline and URL that are
            % used to interact with the service.
            %
            % Returns the updated BlobLeaseClientBuilder object
            
            % Copyright 2022 The MathWorks, Inc.
            if ~(isa(client,'azure.storage.blob.BlobClient'))
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid client argument');
            end
            builderj = builder.Handle.blobClient(client.Handle);
            builder = azure.storage.blob.specialized.BlobLeaseClientBuilder(builderj);
            
        end

        function builder = containerClient(builder, client)
            % CONTAINERCLIENT Configures the builder based on the passed
            % BlobContainerClient. This will set the HttpPipeline and URL
            % that are used to interact with the service.
            %
            % Returns the updated BlobLeaseClientBuilder object

            % Copyright 2022 The MathWorks, Inc.
            if ~(isa(client,'azure.storage.blob.BlobContainerClient'))
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid client argument');
            end
            builderj = builder.Handle.containerClient(client.Handle);
            builder = azure.storage.blob.specialized.BlobLeaseClientBuilder(builderj);
        end

        function builder = leaseId(builder, id)
            % CONTAINERCLIENT Configures the builder based on the passed
            % BlobContainerClient. This will set the HttpPipeline and URL
            % that are used to interact with the service.
            %
            % Returns the updated BlobLeaseClientBuilder object

            % Copyright 2022 The MathWorks, Inc.
            if ~(ischar(id) || isStringScalar(id))
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid id argument');
            end
            builderj = builder.Handle.leaseId(id);
            builder = azure.storage.blob.specialized.BlobLeaseClientBuilder(builderj);
        end

        function client = buildClient(obj)
            % BUILDCLIENT Creates a BlobLeaseClient based on the
            % configurations set in the builder.
            %
            % Returns a BlobLeaseClient based on the configurations in this
            % builder.

            % Copyright 2022 The MathWorks, Inc.
            
            clientj = obj.Handle.buildClient();
            client = azure.storage.blob.specialized.BlobLeaseClient(clientj);
        
        end
    
    end

end