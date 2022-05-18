function tf = hasManageOwnershipPermission(obj)
% HASMANAGEOWNERSHIPPERMISSION Returns the manage ownership permission status
% The result is returned as a logical.

% Copyright 2022 The MathWorks, Inc.

tf = obj.Handle.hasManageOwnershipPermission();

end