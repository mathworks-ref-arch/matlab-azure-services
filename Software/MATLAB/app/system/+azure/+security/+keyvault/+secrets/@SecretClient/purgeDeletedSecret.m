function purgeDeletedSecret(obj, secretName)
% PURGEDELETEDSECRET Permanently removes a deleted secret, without the
% possibility of recovery. This operation can only be performed on a
% soft-delete enabled vault. This operation requires the secrets/purge
% permission.
%
% Throws an error on failure, does not return anything at all upon success.
%
% Example
%     secretClient.purgeDeletedSecret('mySecretName');


% Copyright 2022 The MathWorks, Inc.

if ~(ischar(secretName) || isStringScalar(secretName))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected secretName to be of type character vector or scalar string');
end

obj.Handle.purgeDeletedSecret(secretName);
    
end