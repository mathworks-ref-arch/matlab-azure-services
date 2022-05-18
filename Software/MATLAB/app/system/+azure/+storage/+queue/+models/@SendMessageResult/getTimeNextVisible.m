function timeNextVisible = getTimeNextVisible(obj)
% GETTIMENEXTVISIBLE Get the timeNextVisible property
% The time that the message will again become visible in the Queue.
% A datetime value is returned, with time zone configured for UTC.

% Copyright 2021 The MathWorks, Inc.

timeNextVisiblej = obj.Handle.getTimeNextVisible();
timeNextVisible = datetime(timeNextVisiblej.toEpochSecond(), "ConvertFrom", 'posixtime', "TimeZone", 'UTC');

end