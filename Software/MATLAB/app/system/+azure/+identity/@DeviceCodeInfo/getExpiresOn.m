function expires = getExpiresOn(obj)
% GETEXPIRESON Gets the expiration time of device code.
% Returns a datetime object.

% Copyright 2022 The MathWorks, Inc.

expires = datetime(obj.Handle.getExpiresOn().toEpochSecond(),'ConvertFrom','posixtime','timezone','local');

end