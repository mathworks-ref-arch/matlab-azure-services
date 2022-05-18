classdef ClientSecretCredentialBuilder < azure.identity.CredentialBuilderBase
    % CLIENTSECRETCREDENTIALBUILDER Builder for ClientSecretCredentialBuilder

    % Copyright 2020-2021 The MathWorks, Inc.

    properties
    end

    methods

        function obj = ClientSecretCredentialBuilder(varargin)

            initialize('loggerPrefix', 'Azure:Common');
            if nargin == 0
                obj.Handle = com.azure.identity.ClientSecretCredentialBuilder();
            elseif nargin == 1 && isa(varargin{1}, 'com.azure.identity.ClientSecretCredentialBuilder')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid argument(s)');
            end

        end %function

    end %methods
end %class