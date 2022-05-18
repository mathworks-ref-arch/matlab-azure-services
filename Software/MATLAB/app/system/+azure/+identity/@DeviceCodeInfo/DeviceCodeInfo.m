classdef DeviceCodeInfo < azure.object
% DEVICECODEINFO Contains details of a device code request.

% Copyright 2022 The MathWorks, Inc.

methods
    function obj = DeviceCodeInfo(varargin)
        if nargin == 0
            logObj = Logger.getLogger();
            write(logObj,'error','DeviceCodeInfo can only be instantiated based on an existing Java DeviceCodeInfo.');
        elseif nargin == 1
            deviceCodeInfo = varargin{1};
            if ~isa(deviceCodeInfo, 'com.azure.identity.DeviceCodeInfo')
                logObj = Logger.getLogger();
                write(logObj,'error','Expected argument of type com.azure.identity.DeviceCodeInfo');
            end
            obj.Handle = deviceCodeInfo;
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid number of arguments');
        end     
    end
end
end