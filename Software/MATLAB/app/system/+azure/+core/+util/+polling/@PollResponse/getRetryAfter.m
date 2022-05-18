function delay = getRetryAfter(obj)
% GETRETRYAFTER Gets requested delay until next polling operation is performed
% If a negative value is returned the poller should determine on its own when
% the next poll operation is to occur.

% Copyright 2021 The MathWorks, Inc.

% Returns a Java duration
delayj = obj.Handle.getRetryAfter();

% toMillis() Converts this duration to the total length in milliseconds.
% A null or negative value will be taken to mean that the poller should
% determine on its own when the next poll operation is to occur.
millis = delayj.toMillis();

if isempty(millis)
    % if a null is returned treat the resulting empty as a negative duration: -1s
    delay = duration(0, 0, -1);
else
    % Hours, minutes and seconds set to 0
    delay = duration(0, 0, 0, millis);
end

end