classdef SharedTokenCacheCredentialBuilder < azure.identity.CredentialBuilderBase
% SHAREDTOKENCACHECREDENTIALBUILDER Builder for SharedTokenCacheCredential

% Copyright 2022 The MathWorks, Inc.

properties
end

methods
    function obj = SharedTokenCacheCredentialBuilder(varargin)

        initialize('loggerPrefix', 'Azure:Common');
        
        if nargin == 0
            obj.Handle = com.azure.identity.SharedTokenCacheCredentialBuilder();
        elseif nargin == 1 && isa(varargin{1}, 'com.azure.identity.SharedTokenCacheCredentialBuilder')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end
    end
end

end