function url = getVerificationUrl(obj)
% GETVERIFICATIONURL Gets the URL where user can authenticate.
% Returns a character vector.

% Copyright 2022 The MathWorks, Inc.

url = char(obj.Handle.getVerificationUrl());

end