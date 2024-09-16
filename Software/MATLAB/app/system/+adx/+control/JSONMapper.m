classdef (Abstract) JSONMapper < handle
    % adx.control.JSONMapper base class - adds JSON serialization and deserialization.
    % Derive MATLAB classes from this class to allow them to be
    % deserialized from JSON mapping the JSON fields to the class
    % properties. To allow proper nesting of object, derived objects must
    % call the adx.control.JSONMapper constructor from their constructor:
    %
    % function obj = myClass(s,inputs)
    %     arguments
    %         s {adx.control.JSONMapper.ConstructorArgument} = []
    %         inputs.?myClass
    %     end
    %     obj@adx.control.JSONMapper(s,inputs);
    % end
    %
    % Make sure to update the class name (myClass in the example) in both
    % the function name as well as in the arguments block.
    %
    % During serialization or deserialization the MATLAB object definition
    % is leading. JSON data is converted to MATLAB data types based on the
    % type declaration in MATLAB. Therefore all properties of the MATLAB
    % class *must* have a type declaration. Also, fields are only
    % deserialized if they actually exist on the MATLAB class, any
    % additional fields in the JSON input are ignored.
    %
    % Supported property datatypes: double, float, uint8, int8, uint16,
    % int16, uint32, int32, uint64, int64, logical, enum, string, char,
    % datetime (must be annotated), containers.Map, classes derived from
    % adx.control.JSONMapper.
    %
    % Annotations can be added to properties as "validation functions".
    %
    % adx.control.JSONMapper Methods:
    %
    %   fieldName      - allows property to be mapped to a JSON field with
    %                    different name
    %   JSONArray      - specifies field is a JSON array
    %   epochDatetime  - for datetime properties specifies in JSON the date
    %                    time is encoded as epoch. Must be the first
    %                    attribute if used
    %   stringDatetime - for datetime properties specifies in JSON the date
    %                    time is encoded as string with a particular format.
    %                    Must be the first attribute if used.
    %   doNotParse     - indicate that a field's JSON should not be parsed.
    %                    if JSONArray is also applied the field will be
    %                    parsed at the array level.


    % Copyright 2022-2024 The MathWorks, Inc.

    properties (Access=private)
        MATLABProperties adx.control.JSONPropertyInfo
    end

    properties (Constant, Access=private)
        MATLABGSON = com.google.gson.GsonBuilder().serializeSpecialFloatingPointValues().create();
    end

    methods (Static)
        function doNotParse(~)

        end

        function fn = fieldName(~,fn)
            % FIELDNAME adx.control.JSONMapper Annotation
            % This can be added to properties if the MATLAB property name
            % and JSON field name differ. For example, when the JSON field
            % name is not a valid MATLAB identifier.
            %
            % Example:
            %
            %   properties
            %       some_field {adx.control.JSONMapper.fieldName(some_field,"some.field")}
            %   end
            %
        end

        function JSONArray(~)
            % JSONARRAY adx.control.JSONMapper Annotation
            % Specified that the JSON field is an array.
            %
            % Ensures that when serializing a MATLAB scalar it is in fact
            % encoded as a JSON array rather than a scalar if the property
            % has been annotated with this option.
        end

        function out = epochDatetime(in,options)
            % EPOCHDATETIME adx.control.JSONMapper Annotation
            % When working with datetime fields either epochDatetime or
            % stringDatetime annotation is required to specify how the
            % datetime is encoded in JSON. This must be the first
            % annotation.
            %
            % When called without inputs POSIX time/UNIX timestamp is
            % assumed.
            %
            % Optional Name-Value pairs TimeZone, Epoch and TicksPerSecond
            % can be provided (their meaning is the same as when working
            % with datetime(d,'ConvertFrom','epochtime', OPTIONS).
            %
            % Example:
            %
            %   properties
            %       % start_date is a UNIX timestamp
            %       start_date {adx.control.JSONMapper.epochDatetime}
            %       % end_date is UNIX timestamp in milliseconds
            %       end_date {adx.control.JSONMapper.epochDatetime(end_date,'TicksPerSecond',1000)}
            %   end
            arguments
                in
                options.TimeZone = ''
                options.Epoch = '1970-01-01'
                options.TicksPerSecond = 1;
            end

            if isa(in,'java.lang.String')
                in = string(in);
            end

            % Depending on the input type we are either converting from
            % JSON to datetime or the other way around

            if isstring(in) % From JSON to datetime
                % Value will have been passed as a string such that it can
                % be parsed to int64 without loss of precision. Perform
                % this conversion
                in = sscanf(in,'%ld');
                % Convert to MATLAB datetime

                % propertyClassCoercionException will mask the error in
                % datetime conversion if this is called as part of fromJSON
                % deserializtion of an object hierarchy. Therefore
                % explicitly FPRINTF to stderr any errors here
                try
                    out = datetime(in,'ConvertFrom','epochtime',...
                        'TimeZone',options.TimeZone,...
                        'Epoch',options.Epoch,'TicksPerSecond',options.TicksPerSecond);
                catch ME
                    fprintf(2,'Error in adx.control.JSONMapper: %s\n\n',ME.message);
                end
            elseif isdatetime(in) % From datetime to (JSON) int64
                in.TimeZone = options.TimeZone;
                out = convertTo(in,'epochTime', ...
                    'Epoch',options.Epoch,'TicksPerSecond',options.TicksPerSecond);
            end
        end

        function out = stringDatetime(in,format,options)
            % STRINGDATETIME adx.control.JSONMapper Annotation
            % When working with datetime fields either epochDatetime or
            % stringDatetime annotation is required to specify how the
            % datetime is encoded in JSON. This must be the first
            % annotation.
            %
            % stringDatetime requires the string format as input.
            %
            % Optional Name-Value pair TimeZone can be provided.
            %
            % Example:
            %
            %   properties
            %       start_date {adx.control.JSONMapper.stringDatetime(start_date,'yyyy-MM-dd''T''HH:mm:ss')}
            %   end
            arguments
                in
                format string
                options.TimeZone = ''
            end
            if isa(in,'java.lang.String')
                in = string(in);
            end

            % Depending on the input type we are either converting from
            % JSON to datetime or the other way around

            if isstring(in) || ischar(in) % From JSON to datetime
                % propertyClassCoercionException will mask the error in
                % datetime conversion if this is called as part of fromJSON
                % deserializtion of an object hierarchy. Therefore
                % explicitly FPRINTF to stderr any errors here.

                % Try to parse twice, once with fractional seconds, once
                % without
                try
                    out = datetime(in,'InputFormat', format,'TimeZone',options.TimeZone);
                catch
                    try
                        out = datetime(in,'InputFormat', strrep(format,'.SSS',''),'TimeZone',options.TimeZone);
                    catch ME
                        fprintf(2,'Error in adx.control.JSONMapper: %s\n\n',ME.message);
                    end
                end
            elseif isdatetime(in) % From datetime to (JSON) string
                in.Format = format;
                in.TimeZone = options.TimeZone;
                out = string(in);
            end
        end

        function ConstructorArgument(arg)
            % CONSTRUCTORARGUMENT to be used in derived constructors to
            % allow string or char arrays as input and allows the
            % constructor to be used when working with nested adx.control.JSONMapper
            % derived classes.
            tf = isempty(arg) || isa(arg,'com.google.gson.JsonElement') || isstring(arg) || ischar(arg);
            if (~tf)
                error('JSONMapper:InvalidInput',[...
                    'Input must be either a string or char array which is ' ...
                    'a valid JSON string, or the Name part of a Name-Value ' ...
                    'pair where Name must then be the name of one of the ' ...
                    'class properties.']);
            end
        end
    end

    methods

        function obj = JSONMapper(s,inputs)
            % adx.control.JSONMapper Constructor. Call this from
            % derived classes constructors:
            %
            % function obj = myClass(s,inputs)
            %     arguments
            %         s {adx.control.JSONMapper.ConstructorArgument} = []
            %         inputs.?myClass
            %     end
            %     obj@adx.control.JSONMapper(s,inputs);
            % end
            %
            % Make sure to update the class name (myClass in the example)
            % in both the function name as well as in the arguments block.

            % Ensure that MATLABProperties is initialized
            obj.MATLABProperties = adx.control.JSONPropertyInfo.getPropertyInfo(obj);

            % For backwards compatibility with derived classes with the old
            % constructor do check nargin, for derived classes with the new
            % constructor this should not be necessary
            if nargin > 0
                % If there is an input
                if ~isempty(s)
                    % And it is a JsonElement, string or char
                    if (isa(s,'com.google.gson.JsonElement') || isstring(s) || ischar(s))
                        % Use the helper method to copy values from this
                        % JsonElement to properties of the object
                        obj = obj.fromJSON(s);
                    else
                        error('JSONMapper:InvalidInput','%s constructor was called with an invalid input.',class(obj));
                    end
                end
            end

            % fromInputs behavior
            if nargin > 1
                for p = string(fieldnames(inputs))'
                    obj.(p) = inputs.(p);
                end
            end
        end

        function obj = fromJSON(obj, json)
            useParallel = false;
            try
                % FROMJSON deserializes object from JSON format.
                % Can deserialize whole hierarchies of objects if all classes
                % in the hierarchy derive from adx.control.JSONMapper.
                %
                % Example:
                %   obj = myClass;
                %   obj.fromJSON('{"answer": 42}')

                % If input is char/string, parse it as json, when working with
                % nested objects, this can also be a com.google.gson.JsonObject
                % or JsonArray.

                % If data came in as binary raw bytes, do try to interpret as
                % UTF-8 string
                if isinteger(json)
                    json = native2unicode(json,"UTF-8");
                end

                % If the input is a scalar string/char parse it
                if isstring(json)
                    if isStringScalar(json)
                        json = com.google.gson.JsonParser().parse(json);
                    else
                        error('JSONMapper:fromJSON', "String input must be scalar");
                    end
                else
                    if ischar(json)
                        json = com.google.gson.JsonParser().parse(json);
                    end
                end

                % Ensure input is always an array
                if (~json.isJsonArray())
                    j = com.google.gson.JsonArray();
                    j.add(json);
                    json = j;
                end

                % For all elements in the JSON array
                N = json.size();

                % For an empty array
                if N == 0
                    obj = obj.empty;
                end

                for arrayIndex=1:N
                    % Get the current JSON element from the array
                    curElement = json.get(arrayIndex-1);

                    % For each property in the MATLAB class
                    for curProp = obj(1).MATLABProperties
                        if curProp.doNotParse
                            % If not parsing get the value(s) as a string or an array of strings
                            % If the isArray property is set then split the JSON array into a
                            % string array but the strings are not parsed
                            if ~ismethod(curElement, "has")
                                % e.g. JSON literal: ["outages","unittestdb",null,null,1,45599.0]
                                if curElement.isJsonNull
                                    obj(arrayIndex).(curProp.mName) = string.empty;
                                else
                                    % Strip a leading and trailing pair of
                                    % quotes if present
                                    obj(arrayIndex).(curProp.mName) = string(stripLeadingTrailingPair(char(curElement.toString()), '"'));
                                end
                            elseif curElement.isJsonArray || curElement.isJsonObject
                                if curElement.has(curProp.jName)
                                    if curElement.isJsonNull
                                        % Not parsing the JSON so assigning an empty string
                                        obj(arrayIndex).(curProp.mName) = string.empty;
                                    else
                                        curVal = curElement.get(curProp.jName);
                                        if curVal.isJsonArray
                                            if curProp.isArray
                                                if ismethod(curElement, "isEmpty") && curVal.isEmpty
                                                    obj(arrayIndex).(curProp.mName) = string.empty;
                                                else
                                                    % Can't tell if the array entries are primitive strings
                                                    % which will have quotes or not, don't want to iterate
                                                    % and call is isJsonPrimitive so to allow getAsString()
                                                    % so call toString on all an clean up quotes afterwards
                                                    % in MATLAB
                                                    tIt = org.apache.commons.collections.IteratorUtils.transformedIterator(curVal.iterator, org.apache.commons.collections.functors.InvokerTransformer.getInstance('toString'));
                                                    cArray = cell(org.apache.commons.collections.IteratorUtils.toArray(tIt));
                                                    verbose = true;
                                                    if useParallel && gt(numel(cArray), 1000) && startPool(verbose)
                                                        obj(arrayIndex).(curProp.mName) = parStripLeadingTrailingPair(cArray, '"'); %#ok<UNRCH> % See experimental useParallel flag above
                                                    else
                                                        cArray = arrayfun(@(A) stripLeadingTrailingPair(A, '"'), cArray);
                                                        obj(arrayIndex).(curProp.mName) = convertCharsToStrings(cArray);
                                                        % c. 10x slower, due to Java overhead
                                                        % nElements = curVal.size();
                                                        % obj(arrayIndex).(curProp.mName) = strings(nElements,1);
                                                        % for m = 1:nElements
                                                        %     obj(arrayIndex).(curProp.mName)(m) = curVal.get(m-1).toString();
                                                        % end
                                                    end
                                                end
                                            else
                                                % Strip quotes gson returns on toString
                                                obj(arrayIndex).(curProp.mName) = string(stripLeadingTrailingPair(char(curVal.toString()), '"'));
                                            end
                                        elseif curVal.isJsonNull
                                            obj(arrayIndex).(curProp.mName) = string.empty;
                                        else
                                            % Strip quotes gson returns on toString
                                            obj(arrayIndex).(curProp.mName) = string(stripLeadingTrailingPair(char(curVal.toString()), '"'));
                                        end
                                    end
                                end
                            else
                                error('JSONMapper:fromJSON', "Expected to skip parsing on gson JsonArrays only found class: %s", class(curElement));
                            end
                        else
                            % Parse relative to the MATLAB object

                            % Should only be JsonArray at this point
                            if curElement.isJsonArray || curElement.isJsonObject
                                if ~ismethod(curElement, "has")
                                    warning('JSONMapper:fromJSON', "Unexpected JSON element without has method, skipping: %s", curElement.toString());
                                else
                                    % Check whether property is also present in JSON
                                    if curElement.has(curProp.jName)
                                        % If null assign an empty of the appropriate type
                                        if curElement.isJsonNull
                                            obj(arrayIndex).(curProp.mName) = eval([curProp.dataType.Name '.empty']);
                                        else
                                            % If the property is present in JSON, get this JSONObject
                                            curVal = curElement.get(curProp.jName);
                                            % Now, how to convert this to a MATLAB type is
                                            % governed by the data type specified on the MATLAB
                                            % end. This is especially important for (u)int64
                                            % such that we can avoid loss of precision as well
                                            % as datetime such that we can correctly convert it.
                                            switch curProp.dataType
                                                case {?string,?char}
                                                    obj(arrayIndex).(curProp.mName) = getScalarOrArray(curVal,'string');
                                                case {?single,?double}
                                                    obj(arrayIndex).(curProp.mName) = getScalarOrArray(curVal,'double');
                                                case {?datetime}
                                                    val = arrayfun(curProp.dtConversionFunction,getScalarOrArray(curVal,'string'));
                                                    obj(arrayIndex).(curProp.mName) = val;
                                                case {?duration}
                                                    val = arrayfun(curProp.durConversionFunction,getScalarOrArray(curVal,'string'));
                                                    obj(arrayIndex).(curProp.mName) = val;
                                                case {?int8,?uint8,?int16,?uint16,?int32,?uint32}
                                                    obj(arrayIndex).(curProp.mName) = getScalarOrArray(curVal,'long');
                                                case {?int64}
                                                    obj(arrayIndex).(curProp.mName) = arrayfun(@(x)sscanf(char(x),'%ld'), getScalarOrArray(curVal,'string'));
                                                case {?uint64}
                                                    obj(arrayIndex).(curProp.mName) = arrayfun(@(x)sscanf(char(x),'%lu'), getScalarOrArray(curVal,'string'));
                                                case {?logical}
                                                    obj(arrayIndex).(curProp.mName) = getScalarOrArray(curVal,'bool');
                                                case {?containers.Map}
                                                    map = containers.Map('KeyType','char','ValueType','char');
                                                    it = curVal.entrySet.iterator;
                                                    while it.hasNext
                                                        kv = it.next;
                                                        map(char(kv.getKey)) = char(kv.getValue.getAsString());
                                                    end
                                                    obj(arrayIndex).(curProp.mName) = map;
                                                case {?adx.control.JSONMapperMap}
                                                    map = adx.control.JSONMapperMap;
                                                    it = curVal.entrySet.iterator;
                                                    while it.hasNext
                                                        kv = it.next;
                                                        map(char(kv.getKey)) = char(kv.getValue.getAsString());
                                                    end
                                                    obj(arrayIndex).(curProp.mName) = map;
                                                case {?meta.class} % freeform object, decode as struct
                                                    obj(arrayIndex).(curProp.mName) = jsondecode(char(curVal.toString()));
                                                otherwise
                                                    if isenum(obj(1).(curProp.mName))
                                                        obj(arrayIndex).(curProp.mName) = arrayfun(@(x)obj(arrayIndex).(curProp.mName).fromJSON(x),getScalarOrArray(curVal,'string'));
                                                    else
                                                        obj(arrayIndex).(curProp.mName) = curVal;
                                                    end
                                            end
                                        end
                                    else
                                        % If the field is not present in the JSON data and
                                        % not null, explicitly set the object property to
                                        % empty of the correct class, this allows the same
                                        % method to also be used for refreshing existing
                                        % objects and not only for filling in properties in
                                        % new objects
                                        obj(arrayIndex).(curProp.mName) = eval([curProp.dataType.Name '.empty']);
                                    end
                                end
                            else
                                error('JSONMapper:fromJSON', "Expected to parse gson JsonArrays only found class: %s", class(curElement));
                            end
                        end
                    end
                end
            catch ME
                fprintf(2,'%s\n',ME.getReport);
                rethrow(ME)
            end
        end


        function json = jsonencode(obj,raw)
            % JSONENCODE serializes object as JSON
            % Can serialize whole hierarchies of objects if all classes
            % in the hierarchy derive from adx.control.JSONMapper.
            %
            % The function should only ever be called with one input: the
            % object to be serialized. The second input is only meant to be
            % used internally when jsonencode is called recursively.
            %
            % Example:
            %
            %   json = jsonencode(obj);

            % External call
            if nargin==1
                raw = false;
            end

            % Determine whether input is an array
            isArray = length(obj) > 1;
            if isArray
                arr = com.google.gson.JsonArray;
            end
            % Start a new JsonObject for the current array element
            jObject = com.google.gson.JsonObject;
            % For all elements in the array
            for arrayIndex=1:length(obj)

                % For all properties on the MATLAB class
                for currProp = obj(arrayIndex).MATLABProperties
                    % Only include if the property actually has been set at
                    % all on MATLAB end
                    if isempty(obj(arrayIndex).(currProp.mName))
                        continue
                    end
                    % Again the MATLAB datatype is leading to determine how
                    % data gets serialized.
                    switch currProp.dataType
                        case {?datetime}
                            dt = obj(arrayIndex).(currProp.mName);
                            val = feval(currProp.dtConversionFunction,dt);
                            jObject.add(currProp.jName,getJSONScalarOrArray(val,currProp.isArray));
                        case {?duration}
                            dur = obj(arrayIndex).(currProp.mName);
                            val = feval(currProp.durConversionFunction,dur);
                            jObject.add(currProp.jName,getJSONScalarOrArray(val,currProp.isArray));
                        case {?single,?double,...
                                ?int8,?uint8,?int16,?uint16,?int32,?uint32,...
                                ?string,?char,...
                                ?int64,...
                                ?logical}
                            jObject.add(currProp.jName,getJSONScalarOrArray(obj(arrayIndex).(currProp.mName),currProp.isArray));
                        case {?uint64}
                            v = obj(arrayIndex).(currProp.mName);
                            if length(v) == 1 && ~currProp.isArray %#ok<ISCL> % Warning in >=24a
                                val = java.math.BigInteger(sprintf('%lu',v));
                            else
                                val = javaArray('java.math.BigInteger',length(v));
                                for i=1:length(v)
                                    val(i) =  java.math.BigInteger(sprintf('%lu',v(i)));
                                end
                            end
                            jObject.add(currProp.jName,adx.control.JSONMapper.MATLABGSON.toJsonTree(val));
                        case {?containers.Map}
                            vals = obj(arrayIndex).(currProp.mName).values;
                            keys = obj(arrayIndex).(currProp.mName).keys;
                            m = com.google.gson.JsonObject;
                            for i=1:length(vals)
                                m.add(keys{i},adx.control.JSONMapper.MATLABGSON.toJsonTree(vals{i}));
                            end
                            jObject.add(currProp.jName,m);
                        case {?meta.class, ?adx.control.JSONMapperMap} % free form
                            % Use built-in jsonencode to get a JSON string,
                            % parse back using JsonParser and add to the tree
                            v = obj(arrayIndex).(currProp.mName);
                            jObject.add(currProp.jName,com.google.gson.JsonParser().parse(jsonencode(v)));
                        otherwise
                            if isenum(obj(arrayIndex).(currProp.mName))
                                jObject.add(currProp.jName,getJSONScalarOrArray([obj(arrayIndex).(currProp.mName).JSONValue],currProp.isArray));
                            else
                                jObject.add(currProp.jName,getJSONScalarOrArray(jsonencode(obj(arrayIndex).(currProp.mName),true),currProp.isArray));
                            end
                    end
                end
                % If input was an array, add object to the array
                % a new one
                if isArray
                    arr.add(jObject)
                    jObject = com.google.gson.JsonObject;
                end
            end
            % Full JSON has been built.

            % Now return the output as string if raw == false or as
            % JsonElement when raw == true
            if isArray
                if raw
                    json = arr;
                else
                    json = char(adx.control.JSONMapper.MATLABGSON.toJson(arr));
                end
            else
                if raw
                    json = jObject;
                else
                    json = char(adx.control.JSONMapper.MATLABGSON.toJson(jObject));
                end
            end
        end

        function json = getPayload(obj,requiredProperties,optionalProperties)
            % GETPAYLOAD JSON encodes the object taking into account
            % required and optional properties.
            %
            % Verifies that required properties have indeed been set.
            % Includes optional properties in the output. All other
            % properties are not included in the output.


            % Actually first simply encode the whole thing
            json = jsonencode(obj,true);

            % And then go through all properties, checking the required are
            % indeed there and ignored properties are actively removed
            % again
            for prop = obj.MATLABProperties
                if ~isempty(requiredProperties) && ismember(prop.mName,requiredProperties)
                    if ~json.has(prop.jName)
                        if prop.isArray
                            % In case of a required array set to an empty
                            % array
                            json.add(prop.jName,com.google.gson.JsonArray)
                        else
                            % If required but not set throw an error
                            error('JSONMAPPER:ERROR','Property "%s" must be set.',prop.mName)
                        end
                    else
                        % If required and set, leave it

                    end
                elseif ~isempty(optionalProperties) && ismember(prop.mName,optionalProperties)
                    if ~isempty(obj.(prop.mName))
                        % If optional and set, keep

                    end
                else
                    if ~isempty(obj.(prop.mName)) && ~(isempty(optionalProperties) && isempty(requiredProperties))
                        % If not used but set, warn and remove
                        json.remove(prop.jName);
                        warning('JSONMAPPER:IGNOREDPROPERTYSET','Property "%s" has explicitly been set but will be ignored.',prop.mName)
                    else
                        % Property was set and both requiredProperties and
                        % optionalProperties were entirely empty. This may
                        % happen in oneOf, anyOf, allOf cases. In that case
                        % assume the end-user knows what they are doing and
                        % just keep the property without errors or warnings
                    end
                end
            end
            % JSON encode the object
            json = char(json.toString());
        end
    end
end

function out = getJSONScalarOrArray(val,forceArray)
    % GETJSONSCALARORARRAY helper function to ensure values are serialized
    % as an array if required.
    if forceArray && ~isa(val,'com.google.gson.JsonArray') && length(val) == 1 %#ok<ISCL> % Warning in >=24a
        out = com.google.gson.JsonArray();
        out.add(adx.control.JSONMapper.MATLABGSON.toJsonTree(val));
    else
        out = adx.control.JSONMapper.MATLABGSON.toJsonTree(val);
    end
end

function val = getScalarOrArray(curVal,type)
    % GETSCALARORARRAY helper function which can return MATLAB datatypes
    % from an JsonArray as well as JsonObject.

    if curVal.isJsonArray()
        switch type
            case 'double'
                t = java.lang.Class.forName('[D');
            case 'long'
                t = java.lang.Class.forName('[J');
            case 'string'
                t = java.lang.Class.forName('[Ljava.lang.String;');
            case 'bool'
                t = java.lang.Class.forName('[Z');
        end
    else
        switch type
            case 'double'
                t = java.lang.Double.TYPE;
            case 'long'
                t = java.lang.Long.TYPE;
            case 'string'
                t = java.lang.Class.forName('java.lang.String');
            case 'bool'
                t = java.lang.Boolean.TYPE;
        end
    end
    val = adx.control.JSONMapper.MATLABGSON.fromJson(curVal,t);
    if type == "string"
        val = string(val);
    end
end

function result = stripLeadingTrailingPair(str, stripCharacter)
    % stripLeadingTrailingPair Remove a leading an trailing pair of stripCharacter
    % If only on stripCharacter is found it is not removed.
    % stripCharacter must be a single character only.
    % str and stripCharacter must be a scalar strings or character vectors.
    % If str is a scalar string a scalar string is returned.
    % If str is a character vector a character vector is returned.

    if iscell(str)
        if length(str) > 1 && height(str) > 1
            error("JSONMAPPER:STRIPLEADINGTRAILINGPAIR", "Expected one array dimension to be 0 or 1");
        end
        result = cell(size(str));
        for n = 1:numel(str)
            result{n} = stripLeadingTrailingPair(str{n}, stripCharacter);
        end
    else
        if strlength(stripCharacter) ~= 1
            error("JSONMAPPER:STRIPLEADINGTRAILINGPAIR", "Only a single leading and trailing character can be stripped");
        end

        if ~isStringScalar(str) && ~ischar(str)
            error("JSONMAPPER:STRIPLEADINGTRAILINGPAIR", "Input text must be a scalar string or character vector");
        end

        sl = strlength(str);

        if sl < 2
            result = str;
        elseif sl == 2
            if startsWith(str, stripCharacter) && endsWith(str, stripCharacter)
                if ischar(str)
                    result = '';
                else
                    result = "";
                end
            else
                result = str;
            end
        else
            if startsWith(str, stripCharacter) && endsWith(str, stripCharacter)
                result = extractBetween(str, 2, sl-1);
            else
                result = str;
            end
        end
    end
end

function resultStr = parStripLeadingTrailingPair(strCell, stripCharacter)

    fprintf("Processing: %d fields in parallel in parStripLeadingTrailingPair\n", numel(strCell));

    resultStr = strings(size(strCell));
    parfor n = 1:numel(strCell)

        str = strCell{n};

        if strlength(stripCharacter) ~= 1
            error("JSONMAPPER:STRIPLEADINGTRAILINGPAIR", "Only a single leading and trailing character can be stripped");
        end

        if ~isStringScalar(str) && ~ischar(str)
            error("JSONMAPPER:STRIPLEADINGTRAILINGPAIR", "Input text must be a scalar string or character vector");
        end

        sl = strlength(str);

        if sl < 2
            result = str;
        elseif sl == 2
            if startsWith(str, stripCharacter) && endsWith(str, stripCharacter)
                if ischar(str)
                    result = '';
                else
                    result = "";
                end
            else
                result = str;
            end
        else
            if startsWith(str, stripCharacter) && endsWith(str, stripCharacter)
                result = extractBetween(str, 2, sl-1);
            else
                result = str;
            end
        end
        resultStr(n) = string(result);
    end
end


function doParfor = startPool(verbose)
    if isempty(ver('parallel'))
        if verbose
            fprintf("Parallel Computing Toolbox is not available\n");
        end
        doParfor = false;
        return;
    end

    pool = gcp('nocreate');
    if isempty(pool)
        % Note the default decoder requires a process based pool as opposed to "Threads"
        % because of its use of Java, which might otherwise be preferable
        pool = parpool('Threads');
        % pool = parpool('Processes');
    end

    if isa(pool, 'parallel.ThreadPool')
        doParfor = true;
        if verbose
            fprintf("Found a thread based pool, number of workers in the pool: %d\n", pool.NumWorkers);
        end
    elseif isprop(pool,'Cluster') &&  isprop(pool.Cluster,'Profile') && strcmp(pool.Cluster.Profile, 'Processes')
        doParfor = true;
        if verbose
            fprintf("Found a process based pool, number of workers in the pool: %d\n", pool.NumWorkers);
        end
    else
        % Overhead of a remote cluster may not be justified
        doParfor = false;
        if verbose
            fprintf("Found a parpool which is not process or thread based, rows will be processed serially.\n");
        end
    end
end