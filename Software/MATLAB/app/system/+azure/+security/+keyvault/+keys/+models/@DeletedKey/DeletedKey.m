classdef DeletedKey < azure.security.keyvault.keys.models.KeyVaultKey
    % DELETEDKEY Deleted Key is the resource consisting of name, recovery
    % id, deleted date, scheduled purge date and its attributes inherited
    % from KeyVaultKey. It is managed by Key Service.
    %
    % DeletedKey follows the Azure KeyVault Java SDK design, meaning that
    % DeletedKey inherits from KeyVaultKey, giving DeletedKey methods like
    % getKey and getName. It appears however that some of those methods do
    % not actually return a value for deleted keys and it even appears to
    % depend on how the DeletedKey was obtained. A DeletedKey obtained
    % through getDeletedKey *does* appear to return a name when calling
    % getName whereas DeletedKey obtained through listDeletedKeys does
    % *not*. These are all behaviors of the underlying Azure KeyVault Java
    % SDK and not MATLAB specific behaviors.
    %
    % In that sense, to determine the name of a deleted key, it appears the
    % best option is to call getRecoveryId and parse the name from the URI
    % this returns.

    % Copyright 2022 The MathWorks, Inc.
    methods
        function obj = DeletedKey(jDeletedKey)
            obj = obj@azure.security.keyvault.keys.models.KeyVaultKey(jDeletedKey)
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