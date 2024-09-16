classdef QueryV2ResponseRaw < adx.control.JSONMapper
    % QueryV2ResponseRaw Represents a v2 API response prior to conversion to a table or error

    % Copyright 2023-2024 The MathWorks, Inc.

    % Class properties
    properties
        FrameType {adx.control.JSONMapper.JSONArray}
        % DataSetHeader
        Version string
        IsProgressive logical
        % DataTable
        TableId double
        TableKind adx.data.models.TableKind
        TableName string
        Columns adx.data.models.Column {adx.control.JSONMapper.JSONArray}
        Rows string {adx.control.JSONMapper.JSONArray, adx.control.JSONMapper.doNotParse, adx.control.JSONMapper.fieldName(Rows,"Rows")}
        % DataSetCompletion
        HasErrors logical
        Cancelled logical
        OneApiErrors {adx.control.JSONMapper.JSONArray}
        % TableFragment
        FieldCount double
        TableFragmentType adx.data.models.TableFragmentType
        % TableProgress
        TableProgressProp double {adx.control.JSONMapper.fieldName(TableProgressProp,"TableProgress")}
        % TableCompletion
        RowCount double
    end

    % Class methods
    methods
        % Constructor
        function obj = QueryV2ResponseRaw(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.data.models.QueryV2ResponseRaw
            end
            obj@adx.control.JSONMapper(s,inputs);
        end


        % Should be called on the first frame in a QueryV2ResponseRaw only
        function dataSetHeader = getDataSetHeader(obj)
            if isprop(obj,  'FrameType')
                if strcmpi(obj.FrameType, "datasetheader")
                    dataSetHeader = adx.data.models.DataSetHeader(...
                        'Version', obj.Version,...
                        'IsProgressive', obj.IsProgressive);
                else
                    error("adx:QueryV2ResponseRaw","Expected first frame to be a DataSetHeader, found: %s", obj.FrameType);
                end
            else
                error("adx:QueryV2ResponseRaw","Expected first frame to the have a FrameType property");
            end
        end


        function dataSetCompletion = getDataSetCompletionFrame(obj)
            if isprop(obj, 'FrameType')
                if strcmpi(obj.FrameType, "dataSetCompletion")
                    dataSetCompletion = adx.data.models.DataSetCompletion(...
                        'HasErrors', obj.HasErrors,...
                        'Cancelled', obj.Cancelled,...
                        'OneApiErrors', obj.OneApiErrors);
                else
                    error("adx:QueryV2ResponseRaw","Expected last frame to be a DataSetCompletion, found: %s", obj.FrameType);
                end
            else
                error("adx:QueryV2ResponseRaw","Expected last frame to the have a FrameType property");
            end
        end

    end %methods
end