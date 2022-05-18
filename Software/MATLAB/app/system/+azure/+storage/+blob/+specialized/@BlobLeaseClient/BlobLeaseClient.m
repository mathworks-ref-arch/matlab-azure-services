classdef BlobLeaseClient < azure.object
% BLOBLEASECLIENT This class provides a client that contains all the
% leasing operations for BlobContainerClient and BlobClient. This client
% acts as a supplement to those clients and only handles leasing
% operations.

% Copyright 2022 The MathWorks, Inc.

    properties
    end
    
    methods
        function obj = BlobLeaseClient(varargin)
            initialize('loggerPrefix', 'Azure:ADLSG2');
    
            if nargin == 1 && isa(varargin{1}, 'com.azure.storage.blob.specialized.BlobLeaseClient')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid argument(s)');
            end
        end

        function id = getLeaseId(client)
            % GETLEASEID Get the lease ID for this lease.

            % Copyright 2022 The MathWorks, Inc.
            id = char(client.Handle.getLeaseId());
        end

        function url = getResourceUrl(client)
            % GETRESOURCEURL Gets the URL of the lease client.

            % Copyright 2022 The MathWorks, Inc.
            url = char(client.Handle.getResourceUrl());
        end

        function id = acquireLease(client,duration)
            % ACQUIRELEASE Acquires a lease for write and delete
            % operations. The lease duration must be between 15 to 60
            % seconds or -1 for an infinite duration.
            %
            % Returns the lease ID.
            
            % Copyright 2022 The MathWorks, Inc.

            if ~(isnumeric(duration) && isscalar(duration))
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid id argument');
            end
            id = char(client.Handle.acquireLease(duration));
        end
   
        function id = renewLease(client)
            % RENEWLEASE Renews the previously acquired lease.
            %
            % Returns the renewed lease ID.

            % Copyright 2022 The MathWorks, Inc.

            id = char(client.Handle.renewLease());
        end

        function releaseLease(client)
            % RELEASELEASE Releases the previously acquired lease.
            
            % Copyright 2022 The MathWorks, Inc.

            client.Handle.releaseLease();
        end

        function id = changeLease(client, id)
            % CHANGELEASE Changes the lease ID.
            %
            % Returns the new lease ID.

            % Copyright 2022 The MathWorks, Inc.
            if ~(ischar(id) || isStringScalar(id))
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid id argument');
            end
            id = char(client.Handle.changeLease(id));
        end

        function remaining = breakLease(client)
            % BREAKLEASE Breaks the previously acquired lease, if it
            % exists.
            %
            % Returns the remaining time in the broken lease in seconds.

            % Copyright 2022 The MathWorks, Inc.
            remaining = client.Handle.breakLease();
        end

    end

end
