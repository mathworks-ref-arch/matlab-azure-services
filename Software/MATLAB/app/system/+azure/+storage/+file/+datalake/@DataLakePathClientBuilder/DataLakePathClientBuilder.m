classdef DataLakePathClientBuilder < azure.object
% DATALAKEPATHCLIENTBUILDER Aids the configuration and instantiation of DataLakeFileClient

% Copyright 2022 The MathWorks, Inc.

properties
end

methods
    function obj = DataLakePathClientBuilder(varargin)

        initialize('loggerPrefix', 'Azure:ADLSG2');

        if nargin == 0
            obj.Handle = com.azure.storage.file.datalake.DataLakePathClientBuilder();
        elseif nargin == 1 && isa(varargin{1}, 'com.azure.storage.file.datalake.DataLakePathClientBuilder')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end
    end
end

end