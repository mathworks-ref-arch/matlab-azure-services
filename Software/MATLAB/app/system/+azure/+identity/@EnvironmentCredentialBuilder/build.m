function environmentCredential = build(obj)
% BUILD Creates new EnvironmentCredential with the configured options set

% Copyright 2020 The MathWorks, Inc.

environmentCredentialj = obj.Handle.build();
environmentCredential = azure.identity.EnvironmentCredential(environmentCredentialj);

end