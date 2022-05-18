function azureCliCredential = build(obj)
% BUILD Creates new AzureCliCredential with the configured options set

% Copyright 2020 The MathWorks, Inc.

azureCliCredentialj = obj.Handle.build();
azureCliCredential = azure.identity.AzureCliCredential(azureCliCredentialj);

end