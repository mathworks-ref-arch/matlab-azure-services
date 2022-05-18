function secretClient = buildClient(obj)
% BUILDCLIENT Creates a SecretClient based on options configured in the builder

% Copyright 2021 The MathWorks, Inc.

secretClientj = obj.Handle.buildClient();
secretClient = azure.security.keyvault.secrets.SecretClient(secretClientj);

end