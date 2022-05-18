classdef AccessToken < azure.object
% ACCESSTOKEN An immutable access token with a token string and an expiration time
% Can be created based on a corresponding Java com.azure.core.credential.AccessToken
% argument or a token string and an expiry datetime (including a timezone).

% Copyright 2020-2021 The MathWorks, Inc.

methods
    function obj = AccessToken(varargin)
        logObj = Logger.getLogger();

        if nargin == 1
            accessTokenj = varargin{1};
            if isa(accessTokenj, 'reactor.core.publisher.MonoPeekTerminal')
                % Returns a com.azure.identity.implementation.MsalToken
                msalTokenj = accessTokenj.block();
                obj.Handle = msalTokenj;
            elseif isa(accessTokenj, 'com.azure.core.credential.AccessToken')
                obj.Handle = accessTokenj;    
            else
                write(logObj,'error','Expected argument of type com.azure.core.credential.AccessToken or reactor.core.publisher.MonoPeekTerminal');
            end
        elseif nargin == 2
            token = varargin{1};
            if ~(ischar(token) || isStringScalar(token))
                write(logObj,'error','Expected argument of type character vector or scalar string');
            end
            expiresAt = varargin{2};
            if ~(isdatetime(expiresAt) || isscalar(expiresAt))
                write(logObj,'error','Expected argument of type scalar datetime');
            end
            if isnan(tzoffset(expiresAt))
                write(logObj,'error','expiresAt datetime argument must have timezone set');
            end
            % iso8601 format required TZ should be -04:00 format except for 0 offset then returned as Z
            timeCharSeq = char(datetime(expiresAt,'Format','yyyy-MM-dd''T''HH:mm:ssZZZZZ'));
            expiresAtj = java.time.OffsetDateTime.parse(java.lang.StringBuffer(timeCharSeq));
            accessTokenj = com.azure.core.credential.AccessToken(token, expiresAtj);
            obj.Handle = accessTokenj;
        else
            write(logObj,'error','Invalid number of arguments');
        end           
    end
end % methods
end %class