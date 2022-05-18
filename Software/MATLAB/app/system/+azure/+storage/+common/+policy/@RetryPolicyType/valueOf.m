function retryPolicyType = valueOf(name)
% VALUEOF Returns the enum constant of this type with the specified name

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(name) || isStringScalar(name))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected name to be of type character vector or scalar string');
end

retryPolicyTypej = com.azure.storage.common.policy.RetryPolicyType.valueOf(name)

switch upper(char(retryPolicyTypej.toString))
    case 'EXPONENTIAL'
        retryPolicyType = azure.storage.common.policy.RetryPolicyType.EXPONENTIAL;

    case 'FIXED'
        retryPolicyType = azure.storage.common.policy.RetryPolicyType.FIXED;
    
    otherwise
        logObj = Logger.getLogger();
        write(logObj,'error','Unexpected RetryPolicyType value');
end


end