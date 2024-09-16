function uuid = UUID()
    % UUID Returns a UUID string as created by java.util.UUID.randomUUID

    % Copyright 2024 The MathWorks, Inc.

    uuid = string(javaMethod('randomUUID','java.util.UUID'));
end