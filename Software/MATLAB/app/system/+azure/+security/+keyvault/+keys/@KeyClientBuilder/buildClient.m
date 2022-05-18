function keyClient = buildClient(obj)
% BUILDCLIENT Creates a KeyClient based on options configured in the builder

% Copyright 2021 The MathWorks, Inc.

keyClientj = obj.Handle.buildClient();
keyClient = azure.security.keyvault.keys.KeyClient(keyClientj);
    
end