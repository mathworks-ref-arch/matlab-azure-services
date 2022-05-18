function chainedTokenCredentialBuilder = addLast(obj, tokenCredential)
% ADDLAST Adds a credential to try to authenticate at the end of the chain

% Copyright 2020 The MathWorks, Inc.

chainedTokenCredentialBuilderj = obj.Handle.addLast(tokenCredential.Handle);
chainedTokenCredentialBuilder = azure.identity.ChainedTokenCredentialBuilder(chainedTokenCredentialBuilderj);

end