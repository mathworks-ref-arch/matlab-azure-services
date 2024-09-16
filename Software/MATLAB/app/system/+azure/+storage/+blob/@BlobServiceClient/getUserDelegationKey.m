function key = getUserDelegationKey(obj, start, expiry)
% GETUSERDELEGATIONKEY Gets a user delegation key for use with this
% account's blob storage. 
% 
% Note: This method call is only valid when using TokenCredential. I.e. not
% when working with ConnectionString or StorageSharedKey authentication
% approaches.
%
% The function takes two datetime objects as input, the start and expiry
% time of the key's validity.
%
% Returns a UserDelegationKey object.
%
% Example:
%
%   key = sc.getUserDelegationKey(datetime('now'),datetime('now')+hours(1))

% Copyright 2022-2024 The MathWorks, Inc.

if ~isdatetime(start) && ~isdatetime(expiry)
    logObj = Logger.getLogger();
    write(logObj,'error','Expected start and expiry arguments of type datetime');
end

jStart = azure.mathworks.internal.datetime2OffsetDateTime(start);
jExpiry = azure.mathworks.internal.datetime2OffsetDateTime(expiry);

jKey = obj.Handle.getUserDelegationKey(jStart,jExpiry);
key = azure.storage.blob.models.UserDelegationKey(jKey);