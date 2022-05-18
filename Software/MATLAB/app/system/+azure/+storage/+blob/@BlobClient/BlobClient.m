classdef BlobClient < azure.object
% BLOBCLIENT Client performs generic blob operations

% Copyright 2020-2021 The MathWorks, Inc.

properties
end

methods
    function obj = BlobClient(varargin)
        
        if nargin == 1 && isa(varargin{1}, 'com.azure.storage.blob.BlobClient')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end

    end

    function delete(obj,varargin)
        % DELETE BlobClient destructor - in MATLAB delete is a reserved
        % method name for the class destructor. This method does not delete
        % Blobs on Azure. To delete the Azure Blob use the deleteBlob
        % method in MATLAB.
    end
end
end
