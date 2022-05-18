function value = toString(obj)
% TOSTRING Returns a string representation of LongRunningOperationStatus
% Expected values are:
%    FAILED
%    IN_PROGRESS
%    NOT_STARTED
%    SUCCESSFULLY_COMPLETED
%    USER_CANCELLED
%
% A character vector is returned.

% Copyright 2021 The MathWorks, Inc.

value = char(obj.Handle.toString());

end