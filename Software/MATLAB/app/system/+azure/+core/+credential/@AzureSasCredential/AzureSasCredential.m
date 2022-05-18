classdef AzureSasCredential < azure.object
% AZURESASCREDENTIAL A credential that uses a shared access signature to authenticate
%
% See also: https://azuresdkdocs.blob.core.windows.net/$web/java/azure-core/1.20.0/index.html?com/azure/

% Copyright 2021 The MathWorks, Inc.

methods
    function obj = AzureSasSignature(varargin)
        if nargin == 1
            if ischar(varargin{1}) || isStringScalar(varargin{1})
                obj.Handle = com.azure.core.credential.AzureSasCredential(varargin{1});
            elseif isa(varargin{1}, 'com.azure.core.credential.AzureSasCredential')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Expected an argument of type character vector, scalar string or com.azure.core.credential.AzureSasCredential');
            end
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Expected number of arguments');
        end
    end %function
end %methods
end %class