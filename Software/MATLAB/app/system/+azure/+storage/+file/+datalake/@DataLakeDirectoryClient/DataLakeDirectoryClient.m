classdef DataLakeDirectoryClient < azure.object
% DATALAKEDIRECTORYCLIENT Client that contains directory operations for Azure Storage Data Lake
% This client is instantiated through DataLakePathClientBuilder

% Copyright 2022 The MathWorks, Inc.

properties
end

methods
    function obj = DataLakeDirectoryClient(varargin)
        
        if nargin == 1 && isa(varargin{1}, 'com.azure.storage.file.datalake.DataLakeDirectoryClient')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end

    end

    function delete(obj,varargin)
        % DELETE DataLakeDirectoryClient destructor - in MATLAB delete is a reserved
        % method name for the class destructor. This method does not delete
        % files on Azure. To delete the Azure files use the deleteDirectory
        % method in MATLAB.
    end
end

end