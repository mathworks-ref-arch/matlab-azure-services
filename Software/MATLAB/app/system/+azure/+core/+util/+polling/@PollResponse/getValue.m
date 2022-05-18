function value = getValue(obj)
% GETVALUE The value returned as a result of the last successful poll operation
% This can be any custom user defined object, or null if no value was returned
% from the service. The return value will be subject to standard MATLAB to Java
% data type conversion and the following conversions:
%    java.lang.String -> character vector

% Copyright 2021 The MathWorks, Inc.   

valuej = obj.Handle.getValue();

if isa(valuej, 'java.lang.String')
    value = char(valuej);
else
    value = valuej;
end

end