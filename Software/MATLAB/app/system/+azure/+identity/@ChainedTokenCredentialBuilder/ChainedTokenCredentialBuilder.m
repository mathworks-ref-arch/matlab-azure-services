classdef ChainedTokenCredentialBuilder < azure.object
% CHAINEDTOKENCREDENTIALBUILDER Builder for instantiating a ChainedTokenCredential

% Copyright 2020-2021 The MathWorks, Inc.

methods
    function obj = ChainedTokenCredentialBuilder(varargin)

        initialize('loggerPrefix', 'Azure:Common');

        if nargin == 0
            obj.Handle = com.azure.identity.ChainedTokenCredentialBuilder();
        elseif nargin == 1 && isa(varargin{1}, 'com.azure.identity.ChainedTokenCredentialBuilder')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end
    end
end
end