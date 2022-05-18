function keyj = toEc(obj, includePrivateParameters)
% TOEC Converts JSON web key to EC key pair & optionally include the private key
% Include private key if includePrivateParameters set to true
% A key pair of type java.security.KeyPair is returned.

% Copyright 2021 The MathWorks, Inc.

keyj = obj.Handle.toEc(includePrivateParameters);

end
