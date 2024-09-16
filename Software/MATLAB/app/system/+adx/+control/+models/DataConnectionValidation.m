classdef DataConnectionValidation < adx.control.JSONMapper
% DataConnectionValidation Class representing an data connection validation.
% 
% DataConnectionValidation Properties:
%   dataConnectionName - The name of the data connection. - type: string
%   xproperties - type: DataConnection

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % dataConnectionName - The name of the data connection. - type: string
        dataConnectionName string { adx.control.JSONMapper.fieldName(dataConnectionName,"dataConnectionName") }
        % xproperties - type: DataConnection
        xproperties adx.control.models.DataConnection { adx.control.JSONMapper.fieldName(xproperties,"properties") }
    end

    % Class methods
    methods
        % Constructor
        function obj = DataConnectionValidation(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.DataConnectionValidation
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class
