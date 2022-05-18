function chainedTokenCredential = build(obj)
% BUILD Creates new ChainedTokenCredential with the configured options set

% Copyright 2020 The MathWorks, Inc.

chainedTokenCredentialj = obj.Handle.build();
chainedTokenCredential = azure.identity.ChainedTokenCredential(chainedTokenCredentialj);

end