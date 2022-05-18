function queueMessageItem = setExpirationTime(obj, expirationTime)
% SETEXPIRATIONTIME  The time the Message was inserted into the Queue
% Expiration time should be of type datetime with a time zone set.
% A QueueMessageItem is returned.

% Copyright 2021 The MathWorks, Inc.

if ~(isdatetime(expirationTime) || isscalar(expirationTime))
    write(logObj,'error','Expected argument of type scalar datetime');
end
if isnan(tzoffset(expirationTime))
    write(logObj,'error','expirationTime datetime argument must have timezone set');
end

% iso8601 format required TZ should be -04:00 format except for 0 offset then returned as Z
timeCharSeq = char(datetime(expiryTime,'Format','yyyy-MM-dd''T''HH:mm:ssZZZZZ'));
% StringBuffer required to provide CharSequence interface
expirationTimej = java.time.OffsetDateTime.parse(java.lang.StringBuffer(timeCharSeq));

queueMessageItemj = obj.Handle.setExpirationTime(expirationTimej);
queueMessageItem = azure.storage.queue.models.QueueMessageItem(queueMessageItemj);

end