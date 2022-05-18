classdef BlobServiceClientBuilder < azure.object
% BLOBSERVICECLIENTBUILDER Aids construction of BlobServiceClients

% Copyright 2020-2021 The MathWorks, Inc.

properties
end

methods
    function obj = BlobServiceClientBuilder(varargin)

        initialize('loggerPrefix', 'Azure:ADLSG2');

        if nargin == 0
            obj.Handle = com.azure.storage.blob.BlobServiceClientBuilder();
        elseif nargin == 1 && isa(varargin{1}, 'com.azure.storage.blob.BlobServiceClientBuilder')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end
    end
end

end