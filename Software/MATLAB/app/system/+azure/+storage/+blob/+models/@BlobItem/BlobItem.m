classdef BlobItem < azure.object
    % BlobItem 
   
    % Copyright 2020 The MathWorks, Inc.

    properties
    end

    methods
        function obj = BlobItem(varargin)
            
            if nargin == 1
                if isa(varargin{1}, 'com.azure.storage.blob.models.BlobItem')
                    obj.Handle = varargin{1};
                else
                    logObj = Logger.getLogger();
                    write(logObj,'error','Expected argument of type com.azure.storage.blob.models.BlobItem');
                end                
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Unexpected number of arguments');
            end
        end
    end
end
