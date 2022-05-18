classdef BlobContainerClient < azure.object
% BLOBCONTAINERCLIENT Client to a container

% Copyright 2020-2022 The MathWorks, Inc.

properties
end

    methods
        function obj = BlobContainerClient(varargin)
            if nargin == 1 && isa(varargin{1}, 'com.azure.storage.blob.BlobContainerClient')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','BlobContainerClient must be created using BlobContainerClientBuilder');
            end
        end
    
    
        function delete(obj, varargin)
            % DELETE BlobContainerClient destructor - in MATLAB delete is a
            % reserved method name for the class destructor. This method
            % does not delete Blob Containers on Azure. To delete the Azure
            % Blob Container use the deleteContainer method in MATLAB.
        end
    end
end
