function metadata = getMetadata(obj)
    % GETMETADATA Get the metadata property

    % Copyright 2023 The MathWorks, Inc.

    mj = obj.Handle.getMetadata();

    if isempty(mj)
        metadata = containers.Map.empty;
    else
        % return and entrySet to get an iterator
        entrySetJ = mj.entrySet();
        % get the iterator
        iteratorJ = entrySetJ.iterator();

        % declare empty cell arrays for values and keys
        mKeys = {};
        mValues = {};

        while iteratorJ.hasNext()
            % pick metadata from the entry set one at a time
            entryJ = iteratorJ.next();
            % get the key and the value
            mKey = entryJ.getKey();
            mValue = entryJ.getValue();
            % build the cell arrays of keys and values
            mKeys{end+1} = mKey; %#ok<AGROW>
            mValues{end+1} = mValue; %#ok<AGROW>
        end
        
        if isempty(mKeys)
            metadata = containers.Map.empty;
        else
            metadata = containers.Map(mKeys, mValues);
        end
    end
end