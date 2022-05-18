function tf = hasPrivateKey(obj)
% HASPRIVATEKEY Verifies whether the JsonWebKey has a private key or not
% A logical is returned.

% Copyright 2021 The MathWorks, Inc.

tf = obj.Handle.hasPrivateKey();

end