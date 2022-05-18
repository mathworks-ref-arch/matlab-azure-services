function defaultAzureCredential = build(obj)
% BUILD Creates new DefaultAzureCredential with the configured options set

% Copyright 2020 The MathWorks, Inc.

defaultAzureCredentialj = obj.Handle.build();
defaultAzureCredential = azure.identity.DefaultAzureCredential(defaultAzureCredentialj);

end