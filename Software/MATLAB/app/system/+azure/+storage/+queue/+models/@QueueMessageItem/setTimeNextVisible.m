function queueMessageItem = setTimeNextVisible(obj, timeNextVisible)
% SETTIMENEXTVISIBLE Set the timeNextVisible property
% The time that the message will again become visible in the Queue.
% The time should be of type datetime with a time zone set.
% A QueueMessageItem is returned.

% Copyright 2021 The MathWorks, Inc.

if ~(isdatetime(timeNextVisible) || isscalar(timeNextVisible))
    write(logObj,'error','Expected argument of type scalar datetime');
end
if isnan(tzoffset(timeNextVisible))
    write(logObj,'error','insertionTime datetime argument must have timezone set');
end

% iso8601 format required TZ should be -04:00 format except for 0 offset then returned as Z
timeCharSeq = char(datetime(expiryTime,'Format','yyyy-MM-dd''T''HH:mm:ssZZZZZ'));
% StringBuffer required to provide CharSequence interface
timeNextVisiblej = java.time.OffsetDateTime.parse(java.lang.StringBuffer(timeCharSeq));

queueMessageItemj = obj.Handle.setInsertionTime(timeNextVisiblej);
queueMessageItem = azure.storage.queue.models.QueueMessageItem(queueMessageItemj);

end