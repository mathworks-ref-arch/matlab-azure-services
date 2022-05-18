classdef RequestRetryOptions < azure.object
% REQUESTRETRYOPTIONS Options for configuring the RequestRetryFactory
% The default constructor azure.storage.common.policy.RequestRetryOptions() returns an
% object with retry values:
%
%     retryPolicyType: Optional azure.storage.common.policy.RetryPolicyType Optional
%                      A RetryPolicyType specifying the type of retry pattern
%                      to use, default value is EXPONENTIAL
%
%            maxTries: Optional int32
%                      Maximum number of attempts an operation will be retried
%                      default is 4
%
% tryTimeoutInSeconds: Optional int32
%                      Specifies the maximum time allowed before a request is
%                      cancelled and assumed failed, default is intmax s
%
%      retryDelayInMs: Optional int64
%                      Specifies the amount of delay to use before retrying an
%                      operation, default value is 4ms
%
%   maxRetryDelayInMs: Optional int64
%                      Specifies the maximum delay allowed before retrying an
%                      operation, default value is 120ms
%
%       secondaryHost: Optional character vector or scalar string

% Copyright 2021 The MathWorks, Inc.

properties
end

methods
    function obj = RequestRetryOptions(varargin)
        if nargin == 0
            obj.Handle = azure.storage.common.policy.RequestRetryOptions();
        elseif nargin == 1 && isa(varargin{1}, 'azure.storage.common.policy.RequestRetryOptions')
            obj.Handle = varargin{1};
        elseif nargin > 1
            
            p = inputParser;
            p.CaseSensitive = false;
            validString = @(x) ischar(x) || isStringScalar(x);
            p.FunctionName = mfilename;
            addParameter(p, 'retryPolicyType', azure.storage.common.policy.RetryPolicyType.EXPONENTIAL,...
                                               @(x)isa(x, 'azure.storage.common.policy.RetryPolicyType'));
            addParameter(p, 'maxTries', 4, @isnumeric);
            addParameter(p, 'tryTimeoutInSeconds', intmax, @isnumeric);
            addParameter(p, 'retryDelayInMs', 30, @isnumeric);
            addParameter(p, 'maxRetryDelayInMs', 120, @isnumeric);
            addParameter(p, 'secondaryHost', '', validString);
            parse(p, varargin{:});

            obj.Handle = com.azure.storage.common.policy.RequestRetryOptions(p.Results.retryPolicyType.toJava,...
                                                                         java.lang.Integer(p.Results.maxTries),...
                                                                         java.lang.Integer(p.Results.tryTimeoutInSeconds),...
                                                                         java.lang.Long(p.Results.retryDelayInMs),...
                                                                         java.lang.Long(p.Results.maxRetryDelayInMs),...
                                                                         java.lang.String(p.Results.secondaryHost));
        end
    end
end

end