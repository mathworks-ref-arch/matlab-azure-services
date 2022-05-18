function signature = getSignature(obj)
% GETSIGNATURE Retrieves the shared access signature associated to this credential
% Returns a character vector.
%
% Copyright 2021 The MathWorks, Inc.

signature = char(obj.Handle.getSignature());

end
