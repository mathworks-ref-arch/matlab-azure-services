classdef RowUnparsed < adx.control.JSONMapper
% RowUnparsed Row data returned which is not to be parsed by JSONMapper
% Value is held an an unparsed string

% Copyright 2023 The MathWorks, Inc.

    % Class properties
    properties
        unparsedJSON string {adx.control.JSONMapper.doNotParse}
    end


    % Class methods
    methods
        % Constructor
        function obj = RowUnparsed(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.data.models.RowUnparsed
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end