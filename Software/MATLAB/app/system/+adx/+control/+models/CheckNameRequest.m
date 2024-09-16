classdef CheckNameRequest < adx.control.JSONMapper
% CheckNameRequest The result returned from a database check name availability request.
% 
% CheckNameRequest Properties:
%   name - Resource name. - type: string
%   type - The type of resource, for instance Microsoft.Kusto/clusters/databases. - type: string

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % name - Resource name. - type: string
        name string { adx.control.JSONMapper.fieldName(name,"name") }
        % type - The type of resource, for instance Microsoft.Kusto/clusters/databases. - type: string
        type adx.control.models.CheckNameRequestTypeEnum { adx.control.JSONMapper.fieldName(type,"type") }
    end

    % Class methods
    methods
        % Constructor
        function obj = CheckNameRequest(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.CheckNameRequest
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

