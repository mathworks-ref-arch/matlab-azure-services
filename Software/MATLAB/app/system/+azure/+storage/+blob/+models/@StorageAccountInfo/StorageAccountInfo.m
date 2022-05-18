classdef StorageAccountInfo < azure.object
    % STORAGEACCOUNTINFO Holds information related to the storage account
    % Currently only constructing an object based on and existing java object of
    % type StorageAccountInfo is supported.
   
    % Copyright 2020 The MathWorks, Inc.

    properties
    end

    methods
        function obj = StorageAccountInfo(varargin)
            logObj = Logger.getLogger();

            if nargin == 1
                if isa(varargin{1}, 'com.azure.storage.blob.models.StorageAccountInfo')
                    obj.Handle = varargin{1};
                else
                    write(logObj,'error','Expected argument of type com.azure.storage.blob.models.StorageAccountInfo');
                end                
            else
                write(logObj,'error','Unexpected number of arguments');
            end
        end
    end
end
