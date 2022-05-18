classdef TokenRequestContext < azure.object
% TOKENREQUESTCONTEXT Contains details of a request to get a token
% Can be created based on a corresponding com.azure.core.credential.TokenRequestContext
% Java object argument or without an argument where further configuration is
% required to add scopes.

% Copyright 2020-2021 The MathWorks, Inc.

methods
    function obj = TokenRequestContext(varargin)
        if nargin == 0
            obj.Handle = com.azure.core.credential.TokenRequestContext();
        elseif nargin == 1
            trc = varargin{1};
            if ~isa(trc, 'com.azure.core.credential.TokenRequestContext')
                logObj = Logger.getLogger();
                write(logObj,'error','Expected argument of type com.azure.core.credential.TokenRequestContext');
            end
            obj.Handle = trc;
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid number of arguments');
        end     
    end
end
end