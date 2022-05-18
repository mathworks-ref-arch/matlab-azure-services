function cancelOperation(obj)
% CANCELOPERATION Cancels the remote long-running operation
% Requires cancellation to be supported by the service.

% Copyright 2021 The MathWorks, Inc.   

obj.Handle.cancelOperation();

end
