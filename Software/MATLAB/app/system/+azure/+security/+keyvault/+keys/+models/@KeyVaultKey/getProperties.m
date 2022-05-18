function properties = getProperties(obj)
% GETPROPERTIES Get the key properties
% A azure.security.keyvault.keys.models.KeyProperties is returned.

% Copyright 2021 The MathWorks, Inc.

propj = obj.Handle.getProperties();
properties = azure.security.keyvault.keys.models.KeyProperties(propj);

end