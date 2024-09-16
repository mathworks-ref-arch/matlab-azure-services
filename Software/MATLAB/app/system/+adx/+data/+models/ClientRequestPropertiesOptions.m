classdef ClientRequestPropertiesOptions < adx.control.JSONMapper
% ClientRequestPropertiesOptions Request properties control how a query or command executes and returns results
% See: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/api/netfx/request-properties#clientrequestproperties-options

% Copyright 2023 The MathWorks, Inc.

    % Class properties
    properties
        % Controls the maximum number of HTTP redirects the client follows during processing
        client_max_redirect_count int64
        % If set to true, suppresses reporting of partial query failures within the result set
        deferpartialqueryfailures logical
        % Provides a hint to use the shuffle strategy for referenced materialized views in the query
        materialized_view_shuffle_query string
        % Overrides the default maximum amount of memory a query may allocate per node
        max_memory_consumption_per_query_per_node int64
        % Overrides the default maximum amount of memory a query operator may allocate
        maxmemoryconsumptionperiterator int64
        % Overrides the default maximum number of columns a query is allowed to produce
        maxoutputcolumns int64
        % Sets the request timeout to its maximum value. This option can't be modified as part of a set statement
        norequesttimeout logical
        % Disables truncation of query results returned to the caller
        notruncation logical
        % If set to true, allows pushing simple selection through aggregation
        push_selection_through_aggregation logical
        % Specifies the start value to use when evaluating the bin_auto() function
        query_bin_auto_at string % literal?
        % Specifies the bin size value to use when evaluating the bin_auto() function
        query_bin_auto_size string % literal?
        % Sets the default parameter value for the cursor_after() function when called without parameters
        query_cursor_after_default string
        % Sets the default parameter value for the cursor_before_or_at() function when called without parameters
        query_cursor_before_or_at_default string
        % Overrides the cursor value returned by the cursor_current() function
        query_cursor_current string
        % Disables the usage of cursor functions within the query context
        query_cursor_disabled logical
        % Lists table names to be scoped to cursor_after_default cursor_before_or_at() (upper bound is optional)
        query_cursor_scoped_tables string % dynamic?
        % Controls the data to which the query applies. Supported values are default, all, or hotcache
        query_datascope string
        % Specifies the column name for the query's datetime scope (query_datetimescope_to / query_datetimescope_from)
        query_datetimescope_column string
        % Sets the minimum date and time limit for the query scope. If defined, it serves as an autoapplied filter on query_datetimescope_column
        query_datetimescope_from {adx.control.JSONMapper.stringDatetime(query_datetimescope_from,'yyyy-MM-dd''T''HH:mm:ss')}
        % Sets the maximum date and time limit for the query scope. If defined, it serves as an autoapplied filter on query_datetimescope_column
        query_datetimescope_to {adx.control.JSONMapper.stringDatetime(query_datetimescope_to,'yyyy-MM-dd''T''HH:mm:ss')}
        % Controls the behavior of subquery merge. The executing node introduces an extra level in the query hierarchy for each subgroup of nodes, and this option sets the subgroup size
        query_distribution_nodes_span int32
        % Specifies the percentage of nodes for executing fan-out
        query_fanout_nodes_percent int32
        % Specifies the percentage of threads for executing fan-out
        query_fanout_threads_percent int32
        % If set to true, enforces row level security rules, even if the policy is disabled
        query_force_row_level_security logical 
        % Determines how the query text should be interpreted. Supported values are csl, kql, or sql
        query_language string
        % Enables logging of the query parameters for later viewing in the .show queries journal
        query_log_query_parameters logical
        % Overrides the default maximum number of columns a query is allowed to produce
        query_max_entities_in_union int64
        % Overrides the datetime value returned by the now() function
        query_now {adx.control.JSONMapper.stringDatetime(query_now,'yyyy-MM-dd''T''HH:mm:ss')}
        % If set to true, generates a Python debug query for the enumerated Python node
        query_python_debug logical % or int32 int behavior is not defined
        % If set, retrieves the schema of each tabular data in the results of the query instead of the data itself
        query_results_apply_getschema logical
        % If set to true, forces a cache refresh of query results for a specific query. This option can't be modified as part of a set statement
        query_results_cache_force_refresh logical
        % Controls the maximum age of the cached query results that the service is allowed to return
        query_results_cache_max_age duration {mathworks.internal.adx.duration2Timespan(query_results_cache_max_age)}
        % If set to true, enables per extent query caching. If set to true, enables per extent query caching
        query_results_cache_per_shard logical
        % Provides a hint for how many records to send in each update. Takes effect only if results_progressive_enabled is set
        query_results_progressive_row_count int64
        % Provides a hint for how often to send progress frames. Takes effect only if results_progressive_enabled is set
        query_results_progressive_update_period duration {mathworks.internal.adx.duration2Timespan(query_results_progressive_update_period)}
        % Limits query results to a specified number of records
        query_take_max_records int64
        % Sets the query weak consistency session ID. Takes effect when queryconsistency mode is set to weakconsistency_by_session_id
        query_weakconsistency_session_id string
        % Controls query consistency. Supported values are strongconsistency, weakconsistency, weakconsistency_by_query, weakconsistency_by_database, or weakconsistency_by_session_id. When using weakconsistency_by_session_id, ensure to also set the query_weakconsistency_session_id property
        queryconsistency string
        % Specifies the request application name to be used in reporting. For example, .show queries
        request_app_name string
        % If set to true, blocks access to tables with row level security policy enabled
        request_block_row_level_security logical
        % If set to true, prevents request callout to a user-provided service
        request_callout_disabled logical
        % Allows inclusion of arbitrary text as the request description
        request_description string
        % If set to true, prevents the request from accessing external data using the externaldata operator or external tables
        request_external_data_disabled logical
        % If set to true, prevents the request from accessing external tables
        request_external_table_disabled logical
        % If set to true, indicates that the service shouldn't impersonate the caller's identity
        request_impersonation_disabled logical
        % If set to true, prevents write access for the request
        request_readonly logical
        % If set to true, prevents the request from accessing remote databases and clusters
        request_remote_entities_disabled logical
        % If set to true, prevents the request from invoking code in the sandbox
        request_sandboxed_execution_disabled logical
        % Specifies the request user to be used in reporting. For example, .show queries
        request_user string
        % If set to true, enables the progressive query stream
        results_progressive_enabled logical
        % Overrides the default request timeout. This option can't be modified as part of a set statement
        servertimeout duration {mathworks.internal.adx.duration2Timespan(servertimeout)}
        % Overrides the default maximum number of records a query is allowed to return to the caller (truncation)
        truncation_max_records int64
        % Overrides the default maximum data size a query is allowed to return to the caller (truncation)
        truncation_max_size int64
        % Validates the user's permissions to perform the query without actually running the query. Possible results for this property are: OK (permissions are present and valid), Incomplete (validation couldn't be completed due to dynamic schema evaluation), or KustoRequestDeniedException (permissions weren't set).
        validatepermissions logical
    end

    % Class methods
    methods
        % Constructor
        function obj = ClientRequestPropertiesOptions(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.data.models.ClientRequestPropertiesOptions
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end