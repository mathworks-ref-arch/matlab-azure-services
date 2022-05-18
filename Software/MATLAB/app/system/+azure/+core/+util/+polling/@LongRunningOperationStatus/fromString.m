function longRunningOperationStatus = fromString(name, isComplete)
% FROMSTRING Creates a LongRunningOperationStatus from its string representation
% A name argument of type character vector or scalar string is required.
% A logical isComplete argument is required.
% A azure.core.util.LongRunningOperationStatus is returned.

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(name) || isStringScalar(name))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected name to be of type character vector or scalar string');
end

if ~islogical(isComplete)
    logObj = Logger.getLogger();
    write(logObj,'error','Expected isComplete to be of type logical');
end

longRunningOperationStatusj = com.azure.core.util.LongRunningOperationStatus.fromString(name, isComplete);
longRunningOperationStatus = azure.core.util.LongRunningOperationStatus(longRunningOperationStatusj);

end
