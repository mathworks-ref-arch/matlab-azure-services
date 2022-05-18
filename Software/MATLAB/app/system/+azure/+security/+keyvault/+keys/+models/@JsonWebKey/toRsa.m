function keyj = toRsa(obj, includePrivateParameters)
% TORSA Converts JSON web key to RSA key pair
% Include private key if includePrivateParameters set to true
% A key pair of type java.security.KeyPair is returned.
%
% Example:
%     key = keyClient.getKey('myKeyName');
%     % Return as a jsonWebKey
%     jsonWebKey = key.getKey();
%     % Convert to an RSA key
%     keyRsa = jsonWebKey.toRsa(false);

% Copyright 2021 The MathWorks, Inc.

keyj = obj.Handle.toRsa(includePrivateParameters);

end
