classdef BlobContainerItem < azure.object
    % BLOBCONTAINERITEM An Azure Storage container
   
    % Copyright 2020-2023 The MathWorks, Inc.

    properties
    end

    methods
        function obj = BlobContainerItem(varargin)
            
            if nargin == 1
                if isa(varargin{1}, 'com.azure.storage.blob.models.BlobContainerItem')
                    obj.Handle = varargin{1};
                else
                    logObj = Logger.getLogger();
                    write(logObj,'error','Expected argument of type com.azure.storage.blob.models.BlobContainerItem');
                end
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Unexpected number of arguments');
            end
        end
    end
end
