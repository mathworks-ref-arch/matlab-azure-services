function userCode = getUserCode(obj)
% GETUSERCODE Gets the code which user needs to provide when authenticating
% at the verification URL. 
% Returns a character vector.

% Copyright 2022 The MathWorks, Inc.

userCode = char(obj.Handle.getUserCode());

end