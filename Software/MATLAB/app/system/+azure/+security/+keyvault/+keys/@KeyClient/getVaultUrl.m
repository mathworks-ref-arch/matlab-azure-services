function url = getVaultUrl(obj)
% GETVAULTURL Gets the vault endpoint url to which service requests are sent to
% A character vector is returned.
% A URL has the form: https://<myKeyVaultName>.vault.azure.net/
% The vaultUrl can optionally be stored in the package's JSON configuration file.
    
% Copyright 2021 The MathWorks, Inc.

url = char(obj.Handle.getVaultUrl());

end