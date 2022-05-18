function tf = hasManageAccessControlPermission(obj)
% HASMANAGEACCESSCONTROLPERMISSION Returns the manage access control permission status
% The result is returned as a logical.

% Copyright 2022 The MathWorks, Inc.

tf = obj.Handle.hasManageAccessControlPermission();

end