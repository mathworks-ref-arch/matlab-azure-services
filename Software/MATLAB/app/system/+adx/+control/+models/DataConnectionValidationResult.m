classdef DataConnectionValidationResult < adx.control.JSONMapper
% DataConnectionValidationResult The result returned from a data connection validation request.
% 
% DataConnectionValidationResult Properties:
%   errorMessage - A message which indicates a problem in data connection validation. - type: string

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % errorMessage - A message which indicates a problem in data connection validation. - type: string
        errorMessage string { adx.control.JSONMapper.fieldName(errorMessage,"errorMessage") }
    end

    % Class methods
    methods
        % Constructor
        function obj = DataConnectionValidationResult(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.DataConnectionValidationResult
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

