function value = getValue(obj)
% GETVALUE Returns the secret value
% A character vector is returned.
%
% Example:
%     sc = createKeyVaultClient('Type','Secret');
%     secret = sc.getSecret('mySecretName');
%     secretValue = secret.getValue();

% Copyright 2020-2021 The MathWorks, Inc.

value = char(obj.Handle.getValue());

end