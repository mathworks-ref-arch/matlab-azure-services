classdef ClientCertificateCredentialBuilder < azure.identity.CredentialBuilderBase
    % CLIENTCERTIFICATECREDENTIALBUILDER Builder for ClientCertificateCredential

    % Copyright 2023 The MathWorks, Inc.

    properties
    end

    methods

        function obj = ClientCertificateCredentialBuilder(varargin)

            initialize('loggerPrefix', 'Azure:Common');
            if nargin == 0
                obj.Handle = com.azure.identity.ClientCertificateCredentialBuilder();
            elseif nargin == 1 && isa(varargin{1}, 'com.azure.identity.ClientCertificateCredentialBuilder')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid argument(s)');
            end

        end %function

    end %methods
end %class