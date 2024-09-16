classdef ProvisioningState < adx.control.JSONEnum
% ProvisioningState The provisioned state of the resource.

    % This file is automatically generated using OpenAPI
    % Specification version: 2023-05-02
    % MATLAB Generator for OpenAPI version: 1.0.0
    % (c) 2023 MathWorks Inc.

    enumeration 
        Running ("Running")
        Creating ("Creating")
        Deleting ("Deleting")
        Succeeded ("Succeeded")
        Failed ("Failed")
        Moving ("Moving")
        Canceled ("Canceled")
    end

end %class

