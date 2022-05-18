function queueSasPermission = setAddPermission(obj, permission)
% SETADDPERMISSION Sets the add permission status
% The permission argument should be of type logical.
% A azure.storage.queue.sas.QueueSasPermission object is returned.

% Copyright 2020 The MathWorks, Inc.

if ~islogical(permission)
    logObj = Logger.getLogger();
    write(logObj,'error','permission argument must be of type logical');
end

queueSasPermissionj = obj.Handle.setAddPermission(permission);
queueSasPermission = azure.storage.queue.sas.QueueSasPermission(queueSasPermissionj);

end
