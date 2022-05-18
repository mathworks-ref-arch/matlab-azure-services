classdef DeletedSecret < azure.security.keyvault.secrets.models.KeyVaultSecret
    % DELETEDSECRET Deleted Secret is the resource consisting of name,
    % recovery id, deleted date, scheduled purge date and its attributes
    % inherited from KeyVaultSecret. It is managed by Secret Service.
    %
    % DeletedSecret follows the Azure KeyVault Java SDK design, meaning
    % that DeletedSecret inherits from KeyVaultSecret, giving DeletedSecret
    % methods like getValue. It appears however that this method does not
    % actually return a value for deleted secrets. These are all behaviors
    % of the underlying Azure KeyVault Java SDK and not MATLAB specific
    % behaviors.

    % Copyright 2022 The MathWorks, Inc.
    methods
        function obj = DeletedSecret(jDeletedSecret)
            obj = obj@azure.security.keyvault.secrets.models.KeyVaultSecret(jDeletedSecret)
        end
        function val = getDeletedOn(obj)
            % GETDELETEDON Get the deleted UTC time.
            % A datetime object is returned.
            jOffsetTime = obj.Handle.getDeletedOn();
            val = datetime(jOffsetTime.toEpochSecond(), "ConvertFrom", 'posixtime', "TimeZone", 'UTC');
        end
        function val = getRecoveryId(obj)
            % GETRECOVERYID Get the recoveryId identifier.
            % The URI is returned as character array.
            jRecoveryId = obj.Handle.getRecoveryId();
            val = char(jRecoveryId);

        end
        function val = getScheduledPurgeDate(obj)
            % GETSCHEDULEDPURGEDATE Get the scheduled purge UTC time.
            % A datetime object is returned.
            jOffsetTime = obj.Handle.getScheduledPurgeDate();
            val = datetime(jOffsetTime.toEpochSecond(), "ConvertFrom", 'posixtime', "TimeZone", 'UTC');
        end


    end
end