classdef SuspensionDetails < adx.control.JSONMapper
% SuspensionDetails The database suspension details. If the database is suspended, this object contains information related to the database''s suspension state.
% 
% SuspensionDetails Properties:
%   suspensionStartDate - The starting date and time of the suspension state. - type: datetime

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % suspensionStartDate - The starting date and time of the suspension state. - type: datetime
        suspensionStartDate datetime { adx.control.JSONMapper.stringDatetime(suspensionStartDate,'yyyy-MM-dd''T''HH:mm:ss.SSSZ', 'TimeZone', 'local'), adx.control.JSONMapper.fieldName(suspensionStartDate,"suspensionStartDate") }
    end

    % Class methods
    methods
        % Constructor
        function obj = SuspensionDetails(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.SuspensionDetails
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

