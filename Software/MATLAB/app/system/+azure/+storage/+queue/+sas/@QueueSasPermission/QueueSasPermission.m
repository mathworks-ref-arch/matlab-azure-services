classdef QueueSasPermission < azure.object
% QUEUESASPERMISSION Constructs a string of permissions granted by Account SAS
% Setting a value to true means that any SAS which uses these permissions will
% grant permissions for that operation.
% Once the required values are set, the object should be serialized with
% toString and set as the permissions field on a QueueSasSignatureValues
% object

% Copyright 2021 The MathWorks, Inc.

% It is possible to construct the permissions string without this class,
% but the order of the permissions is particular and this class guarantees
% correctness.

methods (Static)
    queueSasPermission = parse(permString);
end

methods
    function obj = QueueSasPermission(varargin)
        if nargin == 0
            obj.Handle = com.azure.storage.queue.sas.QueueSasPermission();
        elseif nargin == 1
            if isa(varargin{1}, 'com.azure.storage.queue.sas.QueueSasPermission')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Expected argument of type com.azure.storage.queue.sas.QueueSasPermission');
            end                
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Unexpected number of arguments');
        end
    end
end
end    