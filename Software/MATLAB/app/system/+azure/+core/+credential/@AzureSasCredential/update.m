function sasCredential = update(signature)
% UPDATE Rotates the shared access signature associated to this credential
% Returns an updated AzureSasCredential object.

if ischar(signature) || isStringScalar(signature)
    sasCredentialj = obj.Handle.update(signature);
    sasCredential = azure.core.credential.AzureSasCredential(sasCredentialj);
else
    logObj = Logger.getLogger();
    write(logObj,'error','Expected an argument of type character vector or scalar string');
end

end