classdef KeyType
    % KEYTYPE Defines enumeration values for KeyType
    % Values are EC, EC_HSM, OCT, OCT_HSM, RSA & RSA_HSM

    % Copyright 2021 The MathWorks, Inc.

    enumeration
        EC
        EC_HSM
        OCT
        OCT_HSM
        RSA
        RSA_HSM
    end

    methods(Static)
        keyType = fromString(name);
    end
end %class
