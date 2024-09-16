classdef PrivateLinkServiceConnectionStateProperty < adx.control.JSONMapper
% PrivateLinkServiceConnectionStateProperty Connection State of the Private Endpoint Connection.
% 
% PrivateLinkServiceConnectionStateProperty Properties:
%   status - The private link service connection status. - type: string
%   description - The private link service connection description. - type: string
%   actionsRequired - Any action that is required beyond basic workflow (approve/ reject/ disconnect) - type: string

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % status - The private link service connection status. - type: string
        status string { adx.control.JSONMapper.fieldName(status,"status") }
        % description - The private link service connection description. - type: string
        description string { adx.control.JSONMapper.fieldName(description,"description") }
        % actionsRequired - Any action that is required beyond basic workflow (approve/ reject/ disconnect) - type: string
        actionsRequired string { adx.control.JSONMapper.fieldName(actionsRequired,"actionsRequired") }
    end

    % Class methods
    methods
        % Constructor
        function obj = PrivateLinkServiceConnectionStateProperty(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.PrivateLinkServiceConnectionStateProperty
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

