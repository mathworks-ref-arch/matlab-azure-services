classdef LongRunningOperationStatus < azure.object
% LONGRUNNINGOPERATIONSTATUS Represent states of a long-running operation
% The poll operation is considered complete when the status is one of:
% SUCCESSFULLY_COMPLETED, USER_CANCELLED or FAILED.
%
% Possible values are:
%    FAILED
%    IN_PROGRESS
%    NOT_STARTED
%    SUCCESSFULLY_COMPLETED
%    USER_CANCELLED

% Copyright 2021 The MathWorks, Inc.

    properties
    end

    methods
        function obj = LongRunningOperationStatus(varargin)
            if nargin == 1
                if isa(varargin{1}, 'com.azure.core.util.polling.LongRunningOperationStatus')
                    obj.Handle = varargin{1};
                else
                    logObj = Logger.getLogger();
                    write(logObj,'error','Expected argument of type com.azure.core.util.polling.LongRunningOperationStatus or azure.core.util.polling.LongRunningOperationStatus');
                end
            elseif nargin == 0
                obj.Handle = com.azure.core.util.polling.LongRunningOperationStatus();
            end
        end
            

    end

    methods(Static)
        fromString(name, isComplete);        
    end
end
