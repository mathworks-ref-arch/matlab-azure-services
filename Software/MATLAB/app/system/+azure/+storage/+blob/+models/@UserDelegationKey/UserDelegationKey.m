classdef UserDelegationKey < azure.object
% USERDELEGATIONKEY A user delegation key.

% Copyright 2022 The MathWorks, Inc.

    properties
    end
    
    methods
        function obj = UserDelegationKey(varargin)
            initialize('loggerPrefix', 'Azure:ADLSG2');
    
            if nargin == 1 && isa(varargin{1}, 'com.azure.storage.blob.models.UserDelegationKey')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid argument(s)');
            end
        end

        function val = getSignedExpiry(obj)
            % GETSIGNEDEXPIRY Get the signedExpiry property: The date-time
            % the key expires.
            jOffsetTime = obj.Handle.getSignedExpiry();
            val = datetime(jOffsetTime.toEpochSecond(), "ConvertFrom", 'posixtime', "TimeZone", 'UTC');
        end

        function val = getSignedStart(obj)
            %GETSIGNEDSTART Get the signedStart property: The date-time the
            %key is active.
            jOffsetTime = obj.Handle.getSignedStart();
            val = datetime(jOffsetTime.toEpochSecond(), "ConvertFrom", 'posixtime', "TimeZone", 'UTC');
        end        
    end

end
