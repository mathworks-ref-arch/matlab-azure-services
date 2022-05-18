function tokenRequestContext = addScopes(obj, varargin)
% ADDSCOPES Adds one or more scopes to the request scopes
% Scopes should be provided as character vector or scalar string arguments.
% The updated TokenRequestContext is returned.

% Copyright 2020-2021 The MathWorks, Inc.

% Loop through scopes rather than build a Java list
for n = 1:length(varargin)
    scope = varargin{n};
    if ~(ischar(scope) || isStringScalar(scope))
        write(logObj,'error','Expected argument of type character vector or scalar string');
    end
    obj.Handle = obj.Handle.addScopes(scope);
end

tokenRequestContext = obj;

end
