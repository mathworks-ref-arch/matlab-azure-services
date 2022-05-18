classdef PeekedMessageItem < azure.object
    % PEEKEDMESSAGEITEM Returned when calling Peek Messages on a queue
   
    % Copyright 2021 The MathWorks, Inc.

    properties
    end

    methods
        function obj = PeekedMessageItem(varargin)
            if nargin == 1
                if isa(varargin{1}, 'com.azure.storage.queue.models.PeekedMessageItem')
                    obj.Handle = varargin{1};
                else
                    logObj = Logger.getLogger();
                    write(logObj,'error','Expected argument of type com.azure.storage.queue.models.PeekedMessageItem');
                end                
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Unexpected number of arguments');
            end
        end
    end
end
