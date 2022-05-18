classdef PollResponse < azure.object
% POLLRESPONSE Represents a response from long-running polling operation
% It provides information such as the current status of the long-running
% operation and any value returned in the poll.
%
% Can be created based on a corresponding com.azure.core.util.polling.PollResponse
% Java object argument or a com.azure.core.util.polling.LongRunningOperationStatus
% or azure.core.util.polling.LongRunningOperationStatus status argument and a
% message argument of type character vector or scalar string.

% Copyright 2021 The MathWorks, Inc.   
  
properties        
end
    
methods
    function obj = PollResponse(varargin)
        logObj = Logger.getLogger();

        if nargin == 1
            if isa(varargin{1}, 'com.azure.core.util.polling.PollResponse')
                obj.Handle = varargin{1};
            else
                write(logObj,'error','Expected argument of type com.azure.core.util.polling.SyncPoller');
            end
        elseif nargin == 2
            status = varargin{1};
            message = varargin{2};
            if ~(isa(status, 'com.azure.core.util.polling.LongRunningOperationStatus') || ...
               isa(status, 'azure.core.util.polling.LongRunningOperationStatus'))
               write(logObj,'error','Expected status argument of type com.azure.core.util.polling.LongRunningOperationStatus or azure.core.util.polling.LongRunningOperationStatus');
            end
            if ~(ischar(message) || isStringScalar(message))
                write(logObj,'error','Expected message to be of type character vector or scalar string');
            end              
                
            if isa(status, 'azure.core.util.polling.LongRunningOperationStatus')
                obj.Handle = com.azure.core.util.polling.PollResponse(status.Handle, message);
            else
                obj.Handle = com.azure.core.util.polling.PollResponse(status, message);
            end
        else
            write(logObj,'error','Unexpected number of arguments');
        end
    end
end
end
