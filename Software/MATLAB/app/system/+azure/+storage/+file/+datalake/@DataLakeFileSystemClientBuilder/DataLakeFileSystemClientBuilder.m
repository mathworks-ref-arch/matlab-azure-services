classdef DataLakeFileSystemClientBuilder < azure.object
% DATALAKEFILESYSTEMCLIENTBUILDER Aids the configuration and instantiation of DataLakeFileSystemClient

% Copyright 2022 The MathWorks, Inc.

properties
end

methods
    function obj = DataLakeFileSystemClientBuilder(varargin)

        initialize('loggerPrefix', 'Azure:ADLSG2');

        if nargin == 0
            obj.Handle = com.azure.storage.file.datalake.DataLakeFileSystemClientBuilder();
        elseif nargin == 1 && isa(varargin{1}, 'com.azure.storage.file.datalake.DataLakeFileSystemClientBuilder')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end
    end
end

end