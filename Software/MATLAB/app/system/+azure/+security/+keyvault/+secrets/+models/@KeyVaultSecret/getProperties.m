function properties = getProperties(obj)
% GETPROPERTIES Get the secret properties
% A azure.security.keyvault.secrets.models.SecretProperties is returned.

% Copyright 2021 The MathWorks, Inc.

propj = obj.Handle.getProperties();
properties = azure.security.keyvault.secrets.models.SecretProperties(propj);

end