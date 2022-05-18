classdef SyncPoller < azure.object
% SYNCPOLLER Simplifies executing long-running operations against Azure
% There is no constructor as this is based on a Java interface. A SyncPoller
% must be created based on the underlying SyncPoller Java object.

% Copyright 2021 The MathWorks, Inc.
  
properties
end
    
methods
    function obj = SyncPoller(syncPollerJ)
        if isa(syncPollerJ, 'com.azure.core.util.polling.SyncPoller')
            obj.Handle = syncPollerJ;
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Expected argument of type com.azure.core.util.polling.SyncPoller');
        end
    end
end
end
