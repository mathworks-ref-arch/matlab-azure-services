classdef PathSasPermission < azure.object
% PATHSASPERMISSION Constructs a string of permissions granted by ServiceSAS
% Setting a value to true means that any SAS which uses these permissions will
% grant permissions for that operation.

% Copyright 2022 The MathWorks, Inc.

% It is possible to construct the permissions string without this class,
% but the order of the permissions is particular and this class guarantees
% correctness.

methods (Static)
    pathSasPermission = parse(permString);
end

methods
    function obj = PathSasPermission(varargin)
        if nargin == 0
            obj.Handle = com.azure.storage.file.datalake.sas.PathSasPermission();
        elseif nargin == 1
            if isa(varargin{1}, 'com.azure.storage.file.datalake.sas.PathSasPermission')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Expected argument of type com.azure.storage.file.datalake.sas.PathSasPermission');
            end
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Unexpected number of arguments');
        end
    end
end
end    