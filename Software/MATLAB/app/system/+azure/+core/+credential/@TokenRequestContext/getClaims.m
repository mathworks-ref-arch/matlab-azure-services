function tenantId = getClaims(obj)
% GETCLAIMS Get the additional claims to be included in the token
% Returns a character vector.

% Copyright 2021 The MathWorks, Inc.

tenantId = char(obj.Handle.getClaims());

end