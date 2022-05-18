classdef AccountSasService < azure.object
% ACCOUNTSASSERVICE Construct a string representing the Account SAS services
% Setting a value to true means that any SAS which uses these permissions will
% grant access to that service. Once required values are set the object should
% be serialized with toString and set as the services field on an
% AccountSasSignatureValues object.

% Copyright 2020 The MathWorks, Inc.

% It is possible to construct the services string without this class
% but the order of the services is particular and this class guarantees
% correctness.

methods (Static)
    accountSasResourceType = parse(servicesString);
end

methods
    function obj = AccountSasService(varargin)
        if nargin == 0
            obj.Handle = com.azure.storage.common.sas.AccountSasService();        
        elseif nargin == 1
            if isa(varargin{1}, 'com.azure.storage.common.sas.AccountSasService')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Expected argument of type com.azure.storage.common.sas.AccountSasService');
            end                
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Unexpected number of arguments');
        end
    end
end
end    