classdef ListBlobsOptions < azure.object
    % LISTBLOBSOPTIONS Defines options available to configure the behavior of a call to listBlobs on a BlobContainerClient

    % Copyright 2023 The MathWorks, Inc.

    properties
    end

    methods
        function obj = ListBlobsOptions(varargin)
            logObj = Logger.getLogger();

            if nargin == 0
                obj.Handle = com.azure.storage.blob.models.ListBlobsOptions();
            elseif nargin == 1
                if isa(varargin{1}, 'com.azure.storage.blob.models.ListBlobsOptions')
                    obj.Handle = varargin{1};
                else
                    write(logObj,'error','Expected no argument or a com.azure.storage.blob.models.ListBlobsOptions');
                end
            else
                write(logObj,'error','Unexpected number of arguments');
            end
        end
    end
end
