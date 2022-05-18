classdef JsonWebKey < azure.object
% JSONWEBKEY Key as per http://tools.ietf.org/html/draft-ietf-jose-json-web-key-18
% This can be used an intermediate format for converting to other key types or
% for extracting elements of a key.
%
% Example:
%     key = keyClient.getKey('myKeyName');
%     % Return as a jsonWebKey and test if valid
%     jsonWebKey = key.getKey();
%     tf = jsonWebKey.isValid);
%     % Convert to an RSA key
%     keyRsa = jsonWebKey.toRsa(false);

% Copyright 2021 The MathWorks, Inc.

properties
end

methods
    function obj = JsonWebKey(varargin)
        % Create a logger object
        logObj = Logger.getLogger();

        if length(varargin) == 1
            if  isa(varargin{1}, 'com.azure.security.keyvault.keys.models.JsonWebKey')
                obj.Handle = varargin{1};
            else
                write(logObj,'error','Expected argument of type com.azure.security.keyvault.keys.models.JsonWebKey');
            end
        else
            write(logObj,'error','Unexpected number of arguments');
        end
    end
end
end