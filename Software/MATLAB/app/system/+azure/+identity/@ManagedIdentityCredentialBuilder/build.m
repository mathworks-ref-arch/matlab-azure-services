function managedIdentityCredential = build(obj)
% BUILD Creates new ManagedIdentityCredential with the configured options set

% Copyright 2020 The MathWorks, Inc.

managedIdentityCredentialj = obj.Handle.build();
managedIdentityCredential = azure.identity.ManagedIdentityCredential(managedIdentityCredentialj);

end