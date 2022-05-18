classdef QueueProperties < azure.object
% QUEUEPROPERTIES Class containing properties of a specific queue

% Copyright 2021 The MathWorks, Inc.


methods
    function obj = QueueProperties(varargin)
        if nargin == 1
            if isa(varargin{1}, 'com.azure.storage.queue.models.QueueProperties')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Expected argument of type com.azure.storage.queue.models.QueueProperties');
            end                
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Unexpected number of arguments');
        end
    end
end

end
