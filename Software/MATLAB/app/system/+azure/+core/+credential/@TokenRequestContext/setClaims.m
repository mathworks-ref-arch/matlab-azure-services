function tokenRequestContext = setClaims(obj, claims)
% SETCLAIMS Set the additional claims to be included in the token
% The claims should be provided as a character vector or scalar string.
% Returns an updated azure.core.credential.TokenRequestContext.

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(claims) || isStringScalar(claims))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

tokenRequestContextj = obj.Handle.setClaims(claims);
tokenRequestContext = azure.core.credential.TokenRequestContext(tokenRequestContextj);

end