classdef DataLakeFileSystemClient < azure.object
% DATALAKEFILEFILESYSTEMCLIENT Client that contains file system operations
% This client is instantiated through DataLakeFileSystemClientBuilder

% Copyright 2022 The MathWorks, Inc.

properties
end

methods
    function obj = DataLakeFileSystemClient(varargin)
        
        if nargin == 1 && isa(varargin{1}, 'com.azure.storage.file.datalake.DataLakeFileSystemClient')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end

    end

    function delete(obj,varargin)
        % DELETE DataLakeFileSystemClient destructor - in MATLAB delete is a reserved
        % method name for the class destructor. This method does not delete
        % files on Azure. To delete the Azure files use the deleteFileSystem
        % method in MATLAB.
    end
end
end
