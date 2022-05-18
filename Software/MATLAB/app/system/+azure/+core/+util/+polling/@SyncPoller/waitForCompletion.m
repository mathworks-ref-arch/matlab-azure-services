function response = waitForCompletion(obj, varargin)
% WAITFORCOMPLETION Wait for polling to complete with optional timeout
% A azure.core.util.polling.PollResponse is returned.
% An optional timeout can be provided as a scalar number of seconds to
% wait for polling to complete. The value will be converted to an integer value
% of seconds.

% Copyright 2021 The MathWorks, Inc.

if length(varargin) == 1
    timeout = varargin{1};
    if isnumeric(timeout) && isscalar(timeout) && (timeout > 0)
        timeout = int64(timeout);
        durationj = java.time.Duration.ofSeconds(timeout);
    else
        logObj = Logger.getLogger();
        write(logObj,'error','Expected a scalar, positive numeric timeout argument');
    end
elseif length(varargin) > 1
    logObj = Logger.getLogger();
    write(logObj,'error','Unexpected number of arguments');    
end

if length(varargin) == 1
    responsej = obj.Handle.waitForCompletion(durationj);
else
    responsej = obj.Handle.waitForCompletion();
end
response = azure.core.util.polling.PollResponse(responsej);

end
