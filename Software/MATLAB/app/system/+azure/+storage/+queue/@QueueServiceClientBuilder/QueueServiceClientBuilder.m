classdef QueueServiceClientBuilder < azure.object
% QUEUESERVICECLIENTBUILDER Aids configuration & instantiation of QueueServiceClients

% Copyright 2021 The MathWorks, Inc.

properties
end

methods
    function obj = QueueServiceClientBuilder(varargin)

        initialize('loggerPrefix', 'Azure:ADLSG2');

        if nargin == 0
            obj.Handle = com.azure.storage.queue.QueueServiceClientBuilder();
        elseif nargin == 1 && isa(varargin{1}, 'com.azure.storage.queue.QueueServiceClientBuilder')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end
    end
end

end