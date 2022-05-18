function keyj = toAes(obj)
% TOAES Converts JSON web key to AES key
% A key of type javax.crypto.SecretKey is returned.
%
% Example:
%     key = keyClient.getKey('myKeyName');
%     jsonWebKey = key.getKey();
%     keyAes = jsonWebKey.toAes();

% Copyright 2021 The MathWorks, Inc.

keyj = obj.Handle.toAes();

end
