classdef QueueServiceClient < azure.object
% QUEUESERVICECLIENT Service client performs generic queue operations

% Copyright 2020-2021 The MathWorks, Inc.

properties
end

    methods
        function obj = QueueServiceClient(varargin)
            if nargin == 1 && isa(varargin{1}, 'com.azure.storage.queue.QueueServiceClient')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid argument(s)');
            end
        end
    end
end
