classdef RowsUnparsed < adx.control.JSONMapper
% RowsUnparsed Row data returned which is not to be parsed by JSONMapper
% Value is held an an unparsed string

% Copyright 2023 The MathWorks, Inc.

    % Class properties
    properties
        unparsedJSON string
    end


    % Class methods
    methods
        % Constructor
        function obj = RowsUnparsed(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.data.models.RowsUnparsed
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end