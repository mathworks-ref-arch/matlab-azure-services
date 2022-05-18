function deviceCodeCredential = build(obj)
% BUILD Not Supported in MATLAB
%
% When working with DeviceCodeCredential, MATLAB requires the credential
% object to be pre-authorized before passing it to an Azure client. Please
% build and also immediately authorize the DeviceCodeCredential using the
% 'buildAndAuthenticate' method instead.

% Copyright 2022 The MathWorks, Inc.

logObj = Logger.getLogger();
write(logObj,'error',['The ''build'' method is not available in MATLAB.\n\n'...
    'When working with DeviceCodeCredential, MATLAB requires the credential '...
    'object to be pre-authorized before passing it to an Azure client. '...
    'Please build and also immediately authorize the DeviceCodeCredential '...
    'using the ''buildAndAuthenticate'' method instead.']);

end