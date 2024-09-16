classdef ScriptCheckNameRequest < adx.control.JSONMapper
% ScriptCheckNameRequest A script name availability request.
% 
% ScriptCheckNameRequest Properties:
%   name - Script name. - type: string
%   type - The type of resource, Microsoft.Kusto/clusters/databases/scripts. - type: string

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % name - Script name. - type: string
        name string { adx.control.JSONMapper.fieldName(name,"name") }
        % type - The type of resource, Microsoft.Kusto/clusters/databases/scripts. - type: string
        type adx.control.models.ScriptCheckNameRequestTypeEnum { adx.control.JSONMapper.fieldName(type,"type") }
    end

    % Class methods
    methods
        % Constructor
        function obj = ScriptCheckNameRequest(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.ScriptCheckNameRequest
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class
