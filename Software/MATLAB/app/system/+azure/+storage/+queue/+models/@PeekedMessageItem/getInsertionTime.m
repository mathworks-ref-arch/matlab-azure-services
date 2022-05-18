function insertionTime = getInsertionTime(obj)
% GETINSERTIONTIME Get the time the Message was inserted into the queue
% A datetime value is returned, with time zone configured for UTC.

% Copyright 2021 The MathWorks, Inc.

insertionTimej = obj.Handle.getInsertionTime();
insertionTime = datetime(insertionTimej.toEpochSecond(), "ConvertFrom", 'posixtime', "TimeZone", 'UTC');

end