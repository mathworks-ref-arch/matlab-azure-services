function clientSecretCredential = build(obj)
% BUILD Creates new ClientSecretCredential with the configured options set

% Copyright 2020 The MathWorks, Inc.

clientSecretCredentialj = obj.Handle.build();
clientSecretCredential = azure.identity.ClientSecretCredential(clientSecretCredentialj);

end