classdef BlobClientBuilder < azure.object
% BLOBCLIENTBUILDER Aids the configuration and instantiation of BlobClients

% Copyright 2020-2021 The MathWorks, Inc.

properties
end

methods
    function obj = BlobClientBuilder(varargin)

        initialize('loggerPrefix', 'Azure:ADLSG2');

        if nargin == 0
            obj.Handle = com.azure.storage.blob.BlobClientBuilder();
        elseif nargin == 1 && isa(varargin{1}, 'com.azure.storage.blob.BlobClientBuilder')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end
    end
end

end