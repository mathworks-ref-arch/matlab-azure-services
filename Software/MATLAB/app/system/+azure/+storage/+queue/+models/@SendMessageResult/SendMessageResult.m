classdef SendMessageResult < azure.object
% SENDMESSAGERESULT Returned in the QueueMessageList array when calling Put Message on a Queue
   
% Copyright 2021 The MathWorks, Inc.

properties
end

methods
    function obj = SendMessageResult(varargin)
        if nargin == 1
            if isa(varargin{1}, 'com.azure.storage.queue.models.SendMessageResult')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Expected argument of type com.azure.storage.queue.models.SendMessageResult');
            end                
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Unexpected number of arguments');
        end
    end
end

end