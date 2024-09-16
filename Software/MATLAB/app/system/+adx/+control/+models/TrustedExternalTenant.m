classdef TrustedExternalTenant < adx.control.JSONMapper
% TrustedExternalTenant Represents a tenant ID that is trusted by the cluster.
% 
% TrustedExternalTenant Properties:
%   value - GUID representing an external tenant. - type: string

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % value - GUID representing an external tenant. - type: string
        value string { adx.control.JSONMapper.fieldName(value,"value") }
    end

    % Class methods
    methods
        % Constructor
        function obj = TrustedExternalTenant(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.TrustedExternalTenant
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class
