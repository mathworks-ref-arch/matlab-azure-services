classdef QueueItem < azure.object
    % QUEUEITEM Azure Storage Queue 
   
    % Copyright 2021 The MathWorks, Inc.

    properties
    end

    methods
        function obj = QueueItem(varargin)
            
            if nargin == 1
                if isa(varargin{1}, 'com.azure.storage.queue.models.QueueItem')
                    obj.Handle = varargin{1};
                else
                    logObj = Logger.getLogger();
                    write(logObj,'error','Expected argument of type com.azure.storage.queue.models.QueueItem');
                end                
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Unexpected number of arguments');
            end
        end
    end
end
