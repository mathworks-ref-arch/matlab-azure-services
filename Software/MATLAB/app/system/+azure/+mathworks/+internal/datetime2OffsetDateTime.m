function jDateTime = datetime2OffsetDateTime(mDateTime)
% DATETIME2OFFSETDATETIME Converts a MATLAB datetime to a Java
% OffsetDateTime in UTC. Ideally the input MATLAB datetime has a specific
% timezone set already. If no timezone is set, local is assumed.

% Copyright 2022 The MathWorks, Inc.

% If there is no TimeZone set on the MATLAB datetime, set it to local first
% such that later it can be converted to UTC. If we do not set to local
% first, setting to UTC later does not *convert* it just keeps the time as
% is and assumes it has always been in UTC
if isempty(mDateTime.TimeZone)
    mDateTime.TimeZone = 'local';
end

% Whatever the TimeZone was before, now set it to UTC which will really
% convert the datetime to UTC
mDateTime.TimeZone = 'UTC';

% Convert to Java
jDateTime = java.time.OffsetDateTime.ofInstant(...
    java.time.Instant.ofEpochMilli(milliseconds(mDateTime - datetime(0,'ConvertFrom','posixtime','timezone','UTC'))),...
    java.time.ZoneId.of('UTC'));