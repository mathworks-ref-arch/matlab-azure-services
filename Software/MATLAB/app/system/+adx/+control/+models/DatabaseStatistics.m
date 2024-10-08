classdef DatabaseStatistics < adx.control.JSONMapper
% DatabaseStatistics A class that contains database statistics information.
% 
% DatabaseStatistics Properties:
%   size - The database size - the total size of compressed data and index in bytes. - type: double

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % size - The database size - the total size of compressed data and index in bytes. - type: double
        size double { adx.control.JSONMapper.fieldName(size,"size") }
    end

    % Class methods
    methods
        % Constructor
        function obj = DatabaseStatistics(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.DatabaseStatistics
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

