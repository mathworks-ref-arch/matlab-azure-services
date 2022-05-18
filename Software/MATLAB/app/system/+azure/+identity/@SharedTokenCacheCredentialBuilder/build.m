function sharedTokenCacheCredential = build(obj)
% BUILD Creates new SharedTokenCacheCredential with the configured options set

% Copyright 2020 The MathWorks, Inc.

sharedTokenCacheCredentialj = obj.Handle.build();
sharedTokenCacheCredential = azure.identity.SharedTokenCacheCredential(sharedTokenCacheCredentialj);

end