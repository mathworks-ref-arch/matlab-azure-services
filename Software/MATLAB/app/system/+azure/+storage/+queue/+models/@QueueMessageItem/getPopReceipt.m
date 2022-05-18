function receipt = getPopReceipt(obj)
% GETPOPRECEIPT Get the popReceipt, this value is required to delete the Message
% A character vector is returned.

% Copyright 2021 The MathWorks, Inc.

receipt = char(obj.Handle.getPopReceipt());

end
