function expirationTime = getExpirationTime(obj)
% GETEXPIRATIONTIME Get the time the Message was inserted into the queue
% A datetime value is returned, with time zone configured for UTC.

% Copyright 2021 The MathWorks, Inc.

expirationTimej = obj.Handle.getExpirationTime();
expirationTime = datetime(expirationTimej.toEpochSecond(), "ConvertFrom", 'posixtime', "TimeZone", 'UTC');
end