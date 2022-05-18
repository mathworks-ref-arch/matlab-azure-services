classdef QueueClientBuilder < azure.object
% QUEUECLIENTBUILDER Aids the configuration and instantiation of QueueClients

% Copyright 2021 The MathWorks, Inc.

properties
end

methods
    function obj = QueueClientBuilder(varargin)

        initialize('loggerPrefix', 'Azure:ADLSG2');

        if nargin == 0
            obj.Handle = com.azure.storage.queue.QueueClientBuilder();
        elseif nargin == 1 && isa(varargin{1}, 'com.azure.storage.queue.QueueClientBuilder')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end
    end
end

end