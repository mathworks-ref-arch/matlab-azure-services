classdef BlobServiceClient < azure.object
% BLOBSERVICECLIENT

% Copyright 2020 The MathWorks, Inc.

properties
end

methods
    function obj = BlobServiceClient(varargin)
        if nargin == 1 && isa(varargin{1}, 'com.azure.storage.blob.BlobServiceClient')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','BlobServiceClient must be created using BlobServiceClientBuilder');
        end
    end
end

end