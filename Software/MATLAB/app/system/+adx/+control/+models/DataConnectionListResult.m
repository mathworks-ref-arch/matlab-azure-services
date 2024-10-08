classdef DataConnectionListResult < adx.control.JSONMapper
% DataConnectionListResult The list Kusto data connections operation response.
% 
% DataConnectionListResult Properties:
%   value - The list of Kusto data connections. - type: array of DataConnection

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % value - The list of Kusto data connections. - type: array of DataConnection
        value adx.control.models.DataConnection { adx.control.JSONMapper.fieldName(value,"value"), adx.control.JSONMapper.JSONArray }
    end

    % Class methods
    methods
        % Constructor
        function obj = DataConnectionListResult(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.DataConnectionListResult
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

