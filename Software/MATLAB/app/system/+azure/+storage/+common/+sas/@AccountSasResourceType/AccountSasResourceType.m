classdef AccountSasResourceType  < azure.object
% ACCOUNTSASRESOURCETYPE Construct string representing the Account SAS services
% Setting a value to true means that any SAS which uses these permissions will
% grant access to that resource type.
% Once the required values are set serialize the object with toString for use
% as the resources field on an AccountSasSignatureValues object.

% Copyright 2020 The MathWorks, Inc.

% It is possible to construct the resources string without this class,
% but the order of the resources is particular and this class guarantees
% correctness.

methods (Static)
    accountSasResourceType = parse(resourceTypesString);
end

methods
    function obj = AccountSasResourceType(varargin)
        if nargin == 0
            obj.Handle = com.azure.storage.common.sas.AccountSasResourceType();        
        elseif nargin == 1
            if isa(varargin{1}, 'com.azure.storage.common.sas.AccountSasResourceType')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Expected argument of type com.azure.storage.common.sas.AccountSasResourceType');
            end                
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Unexpected number of arguments');
        end
    end
end
end
