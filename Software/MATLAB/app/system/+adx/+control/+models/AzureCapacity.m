classdef AzureCapacity < adx.control.JSONMapper
% AzureCapacity Azure capacity definition.
% 
% AzureCapacity Properties:
%   scaleType - Scale type. - type: string
%   minimum - Minimum allowed capacity. - type: int32
%   maximum - Maximum allowed capacity. - type: int32
%   default - The default capacity that would be used. - type: int32

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % scaleType - Scale type. - type: string
        scaleType adx.control.models.AzureCapacityScaleTypeEnum { adx.control.JSONMapper.fieldName(scaleType,"scaleType") }
        % minimum - Minimum allowed capacity. - type: int32
        minimum int32 { adx.control.JSONMapper.fieldName(minimum,"minimum") }
        % maximum - Maximum allowed capacity. - type: int32
        maximum int32 { adx.control.JSONMapper.fieldName(maximum,"maximum") }
        % default - The default capacity that would be used. - type: int32
        default int32 { adx.control.JSONMapper.fieldName(default,"default") }
    end

    % Class methods
    methods
        % Constructor
        function obj = AzureCapacity(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.AzureCapacity
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

