classdef BlobContainerClientBuilder < azure.object
% BLOBCONTAINERCLIENTBUILDER Aids construction of BlobContinerClients

% Copyright 2020-2021 The MathWorks, Inc.

properties
end

methods
    function obj = BlobContainerClientBuilder(varargin)

        initialize('loggerPrefix', 'Azure:ADLSG2');

        if nargin == 0
            obj.Handle = com.azure.storage.blob.BlobContainerClientBuilder();
        elseif nargin == 1 && isa(varargin{1}, 'com.azure.storage.blob.BlobContainerClientBuilder')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end
    end
end

end