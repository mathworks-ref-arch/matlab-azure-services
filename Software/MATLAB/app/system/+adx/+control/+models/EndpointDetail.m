classdef EndpointDetail < adx.control.JSONMapper
% EndpointDetail Current TCP connectivity information from the Kusto cluster to a single endpoint.
% 
% EndpointDetail Properties:
%   port - The port an endpoint is connected to. - type: int32

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % port - The port an endpoint is connected to. - type: int32
        port int32 { adx.control.JSONMapper.fieldName(port,"port") }
    end

    % Class methods
    methods
        % Constructor
        function obj = EndpointDetail(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.EndpointDetail
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

