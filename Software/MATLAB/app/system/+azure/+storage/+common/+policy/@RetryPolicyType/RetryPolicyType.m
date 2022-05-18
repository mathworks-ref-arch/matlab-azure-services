classdef RetryPolicyType
    % RetryPolicyType Defines holds possible options for retry backoff algorithms
    % They may be used with RequestRetryOptions.
    % Values are EXPONENTIAL & FIXED

    % Copyright 2021 The MathWorks, Inc.

    enumeration
        EXPONENTIAL
        FIXED
    end

    methods(Static)
        retryPolicyType = valueOf(name);
    end
end %class