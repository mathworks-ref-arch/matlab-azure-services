classdef PathItem < azure.object

% Copyright 2022 The MathWorks, Inc.

properties
end

methods
    function obj = PathItem(varargin)
        if nargin == 1 && isa(varargin{1}, 'com.azure.storage.file.datalake.models.PathItem')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument');
        end
    end
end
end