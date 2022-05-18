function retryPolicyTypej = toJava(obj)
% TOJAVA Converts to a com.azure.storage.common.policy.RetryPolicyType Java object

% Copyright 2021 The MathWorks, Inc.

switch upper(obj.toString())
    case 'EXPONENTIAL'
        retryPolicyTypej = com.azure.storage.common.policy.RetryPolicyType.EXPONENTIAL;
    case 'FIXED'
        retryPolicyTypej = com.azure.storage.common.policy.RetryPolicyType.FIXED;
    otherwise
        logObj = Logger.getLogger();
        write(logObj,'error','Unexpected RetryPolicyType value');
end    

end