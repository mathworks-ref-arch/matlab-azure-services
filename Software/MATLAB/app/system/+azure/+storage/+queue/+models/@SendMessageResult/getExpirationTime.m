function expirationTime = getExpirationTime(obj)
% GETEXPIRATIONTIME Time the Message will expire and be automatically deleted
% A datetime value is returned, with time zone configured for UTC.

% Copyright 2021 The MathWorks, Inc.

expirationTimej = obj.Handle.getExpirationTime();

expirationTime = datetime(expirationTimej.toEpochSecond(), "ConvertFrom", 'posixtime', "TimeZone", 'UTC');

end