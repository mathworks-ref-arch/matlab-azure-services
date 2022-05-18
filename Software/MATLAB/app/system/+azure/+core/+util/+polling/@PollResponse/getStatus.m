function longRunningOperationStatus = getStatus(obj)
% GETSTATUS Gets status of a long-running operation at last polling operation

% Copyright 2021 The MathWorks, Inc.   

longRunningOperationStatusj = obj.Handle.getStatus();
longRunningOperationStatus = azure.core.util.polling.LongRunningOperationStatus(longRunningOperationStatusj);

end