function tf = isPrefix(obj)
    % ISPREFIX Get the isPrefix property: If blobs are named to mimic a directory hierarchy

    % Copyright 2023 The MathWorks, Inc.

    tf = obj.Handle.isPrefix;
    if isempty(tf)
        tf = false;
    elseif islogical(tf)
        % do nothing
    elseif isa(tf, 'java.lang.Boolean')
        tf = tf.booleanValue();
    else
       logObj = Logger.getLogger();
       write(logObj,'error','Unexpected isPrefix result'); 
    end
end