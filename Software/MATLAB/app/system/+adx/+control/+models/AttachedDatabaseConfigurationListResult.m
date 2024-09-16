classdef AttachedDatabaseConfigurationListResult < adx.control.JSONMapper
% AttachedDatabaseConfigurationListResult The list attached database configurations operation response.
% 
% AttachedDatabaseConfigurationListResult Properties:
%   value - The list of attached database configurations. - type: array of AttachedDatabaseConfiguration

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % value - The list of attached database configurations. - type: array of AttachedDatabaseConfiguration
        value adx.control.models.AttachedDatabaseConfiguration { adx.control.JSONMapper.fieldName(value,"value"), adx.control.JSONMapper.JSONArray }
    end

    % Class methods
    methods
        % Constructor
        function obj = AttachedDatabaseConfigurationListResult(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.AttachedDatabaseConfigurationListResult
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

