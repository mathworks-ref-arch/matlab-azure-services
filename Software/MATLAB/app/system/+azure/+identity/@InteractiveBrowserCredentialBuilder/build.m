function interactiveBrowserCredential = build(obj)
% BUILD Creates new InteractiveBrowserCredential with the configured options set

% Copyright 2020 The MathWorks, Inc.

interactiveBrowserCredential = obj.Handle.build();
interactiveBrowserCredential = azure.identity.InteractiveBrowserCredential(interactiveBrowserCredential);

end