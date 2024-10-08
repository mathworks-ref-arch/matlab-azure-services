classdef Operation < adx.control.JSONMapper
% Operation No description provided
% 
% Operation Properties:
%   name - This is of the format {provider}/{resource}/{operation}. - type: string
%   display - type: The_object_that_describes_the_operation_
%   origin - type: string
%   xproperties - type: object

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % name - This is of the format {provider}/{resource}/{operation}. - type: string
        name string { adx.control.JSONMapper.fieldName(name,"name") }
        % display - type: The_object_that_describes_the_operation_
        display adx.control.models.The_object_that_describes_the_operation_ { adx.control.JSONMapper.fieldName(display,"display") }
        % origin - type: string
        origin string { adx.control.JSONMapper.fieldName(origin,"origin") }
        % xproperties - type: object
        xproperties  { adx.control.JSONMapper.fieldName(xproperties,"properties") }
    end

    % Class methods
    methods
        % Constructor
        function obj = Operation(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.Operation
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

