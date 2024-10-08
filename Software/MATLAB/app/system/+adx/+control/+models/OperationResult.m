classdef OperationResult < adx.control.JSONMapper
% OperationResult Operation Result Entity.
% 
% OperationResult Properties:
%   id - ID of the resource. - type: string
%   name - Name of the resource. - type: string
%   status - type: Status
%   startTime - The operation start time - type: datetime
%   endTime - The operation end time - type: datetime
%   percentComplete - Percentage completed. - type: double
%   xproperties - type: OperationResultProperties
%   error - type: OperationResultErrorProperties

% This file is automatically generated using OpenAPI
% Specification version: 2023-05-02
% MATLAB Generator for OpenAPI version: 1.0.0
% (c) 2023 MathWorks Inc.

    % Class properties
    properties
        % id - ID of the resource. - type: string
        id string { adx.control.JSONMapper.fieldName(id,"id") }
        % name - Name of the resource. - type: string
        name string { adx.control.JSONMapper.fieldName(name,"name") }
        % status - type: Status
        status adx.control.models.Status { adx.control.JSONMapper.fieldName(status,"status") }
        % startTime - The operation start time - type: datetime
        startTime datetime { adx.control.JSONMapper.stringDatetime(startTime,'yyyy-MM-dd''T''HH:mm:ss.SSSZ', 'TimeZone', 'local'), adx.control.JSONMapper.fieldName(startTime,"startTime") }
        % endTime - The operation end time - type: datetime
        endTime datetime { adx.control.JSONMapper.stringDatetime(endTime,'yyyy-MM-dd''T''HH:mm:ss.SSSZ', 'TimeZone', 'local'), adx.control.JSONMapper.fieldName(endTime,"endTime") }
        % percentComplete - Percentage completed. - type: double
        percentComplete double { adx.control.JSONMapper.fieldName(percentComplete,"percentComplete") }
        % xproperties - type: OperationResultProperties
        xproperties adx.control.models.OperationResultProperties { adx.control.JSONMapper.fieldName(xproperties,"properties") }
        % error - type: OperationResultErrorProperties
        error adx.control.models.OperationResultErrorProperties { adx.control.JSONMapper.fieldName(error,"error") }
    end

    % Class methods
    methods
        % Constructor
        function obj = OperationResult(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.control.models.OperationResult
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end %class

