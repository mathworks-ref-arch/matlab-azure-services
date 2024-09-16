classdef (SharedTestFixtures={adxFixture}) testQuery < matlab.unittest.TestCase
    % testQuery Unit testing for the query API
    
    %  (c) 2023-2024 MathWorks, Inc.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add your test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        clusterName string
        cluster adx.control.models.Cluster
        state adx.control.models.ClusterProperties_1StateEnum
    end

    methods (TestClassSetup)
        function checkCluster(testCase)
            disp("Running checkCluster");
            testCase.clusterName = getenv("ADXCLUSTERNAME");
            % Create a cluster object for the tests
            if strlength(testCase.clusterName) > 1
                c = mathworks.adx.clustersGet(cluster=testCase.clusterName);
            else
                c = mathworks.adx.clustersGet();
            end
            testCase.verifyClass(c, 'adx.control.models.Cluster');
            testCase.cluster = c;
            
            % Check cluster is already running
            testCase.state = testCase.cluster.xproperties.state;
            testCase.verifyClass(testCase.state, 'adx.control.models.ClusterProperties_1StateEnum');
            testCase.verifyEqual(testCase.state, adx.control.models.ClusterProperties_1StateEnum.Running);

            defaultCluster = mathworks.internal.adx.getDefaultConfigValue('cluster');
            mURI = matlab.net.URI(defaultCluster);
            nameFields = split(mURI.Host, ".");
            testCase.verifyEqual(nameFields(1), testCase.cluster.name);
        end
    end

    methods (TestMethodSetup)
        function testSetup(testCase) %#ok<MANU>
        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>
        end
    end

    methods (Test)
        function testHelloWorld(testCase)
            disp("Running testHelloWorld");
            
            request = adx.data.models.QueryRequest();
            testCase.verifyClass(request, 'adx.data.models.QueryRequest');
            colName = "myOutput";
            message = "Hello World";
            % set the KQL query
            request.csl = sprintf('print %s="%s"', colName, message);
            
            % Don't set the database use the default in .json config file
            % request.db = "testdb1"
            % No adx.data.models.ClientRequestProperties required
            % request.requestProperties

            % Create the Query object and run the request
            query = adx.data.api.Query();
            [code, result, response] = query.queryRun(request); %#ok<ASGLU>
            testCase.verifyEqual(code, matlab.net.http.StatusCode.OK);
            
            
            if code == matlab.net.http.StatusCode.OK
                % Convert the response to Tables
                hwTable = mathworks.internal.adx.queryV2Response2Tables(result);
                fprintf("Query (%s) result:\n", request.csl);
                disp(hwTable);
            else
                error('Error running query: %s', request.csl);
            end
        end


        function testKQLQuery(testCase)
            disp("Running testKQLQuery");

            [result, success, requestId] = mathworks.adx.KQLQuery('print mycol="Hello World"');
            
            testCase.verifyTrue(success);
            testCase.verifyEqual(36, strlength(requestId));
            testCase.verifyClass(result, 'table');
            testCase.verifyEqual(result.mycol(1), "Hello World");
            testCase.verifyEqual(1, width(result));
            testCase.verifyEqual(1, height(result));
        end


        function testtSQLQuery(testCase)
            disp("Running testtSQLQuery");

            [result, success, requestId, resultTables, dataSetHeader, dataSetCompletion] = mathworks.adx.tSQLQuery('SELECT top(10) * FROM airlinesmall', nullPolicy=mathworks.adx.NullPolicy.AllowAll); %#ok<ASGLU>

            testCase.verifyTrue(success);
            testCase.verifyEqual(36, strlength(requestId));
            testCase.verifyClass(result, 'table');
            testCase.verifyEqual(result.DayOfWeek{1}, int32(3));
            testCase.verifyEqual(27, width(result));
            testCase.verifyEqual(10, height(result));
            testCase.verifyFalse(dataSetCompletion.HasErrors);
            testCase.verifyFalse(dataSetCompletion.Cancelled);
            testCase.verifyEmpty(dataSetCompletion.OneApiErrors)
        end


        function testProgressive(testCase)
            disp("Running testProgressive");
            tableName = "RandomData";
            query = sprintf('%s | take  1000', tableName);
            args = {"propertyNames", "results_progressive_enabled", "propertyValues", {true}, "verbose", false};
            [result, success, requestId, resultTables, dataSetHeader, dataSetCompletion] = mathworks.adx.KQLQuery(query, args{:}); %#ok<ASGLU>
            testCase.verifyTrue(success);

            % Non progressive version
            [npResult, success, requestId, resultTables, dataSetHeader, dataSetCompletion] = mathworks.adx.run(query); %#ok<ASGLU>
            testCase.verifyTrue(success);
            % Does progressive and non progressive give the same table 
            testCase.verifyEqual(result, npResult);
        end


        function testProgressiveParallel(testCase)
            disp("Running testProgressiveParallel");
            tableName = "RandomData";
            query = sprintf('%s | take  1000', tableName);
            args = {"propertyNames", "results_progressive_enabled", "propertyValues", {true}, "verbose", true, "useParallel", true, "parallelThreshold", 500};
            [result, success, requestId, resultTables, dataSetHeader, dataSetCompletion] = mathworks.adx.KQLQuery(query, args{:}); %#ok<ASGLU>
            testCase.verifyTrue(success);

            % Non progressive no parallel version
            [npResult, success, requestId, resultTables, dataSetHeader, dataSetCompletion] = mathworks.adx.run(query); %#ok<ASGLU>
            testCase.verifyTrue(success);
            % Does progressive and non progressive give the same table 
            testCase.verifyEqual(result, npResult);
        end


        function testV1QqueryHW(testCase)
            disp("Running testV1QqueryHW");
            request = adx.data.models.QueryRequest();
            testCase.verifyClass(request, 'adx.data.models.QueryRequest');
            colName = "myOutput";
            message = "Hello World";
            % set the KQL query
            request.csl = sprintf('print %s="%s"', colName, message);

            % Create the Query object and run the request
            query = adx.data.api.Query();
            [code, result, response] = query.queryRun(request, apiVersion="v1"); %#ok<ASGLU>
            testCase.verifyEqual(code, matlab.net.http.StatusCode.OK);
            
            if code == matlab.net.http.StatusCode.OK
                % Convert the response to Tables
                [hwTable, otherTables] = mathworks.internal.adx.queryV1Response2Tables(result);
                fprintf("Query (%s) result:\n", request.csl);
                disp(hwTable);
                testCase.verifyEqual(height(hwTable), 1);
                testCase.verifyEqual(width(hwTable), 1);
                testCase.verifyEqual(hwTable.Properties.VariableNames{1}, char(colName));
                testCase.verifyEqual(hwTable.(colName)(1), message);
                testCase.verifyClass(otherTables, 'cell');
                testCase.verifyEqual(numel(otherTables), 3);
                testCase.verifyClass(otherTables{1}, 'table');
                testCase.verifyClass(otherTables{2}, 'table');
                testCase.verifyClass(otherTables{3}, 'table');
            else
                error('Error running query: %s', request.csl);
            end
        end


        function testRandomDataV1(testCase)
            disp("Running testRandomDataV1");
            tableName = "RandomData";
            request = adx.data.models.QueryRequest();
            queryStr = sprintf('%s | take  1000', tableName);
            request.csl = queryStr;
            % Create the Query object and run the request
            query = adx.data.api.Query();
            [code, resultRaw, response] = query.queryRun(request, apiVersion="v1"); %#ok<ASGLU>
            testCase.verifyEqual(code, matlab.net.http.StatusCode.OK);
            % Convert the response to Tables
            [result, ~] = mathworks.internal.adx.queryV1Response2Tables(resultRaw);
            % Non progressive v2 version
            [npResult, success, requestId, resultTables, dataSetHeader, dataSetCompletion] = mathworks.adx.run(queryStr); %#ok<ASGLU>
            testCase.verifyTrue(success);
            % Does progressive and non progressive give the same table 
            testCase.verifyEqual(result, npResult);
        end


        function testRandomDataV2skipResponseDecode(testCase)
            disp("Running testRandomDataV2skipResponseDecode");
            tableName = "RandomData";
            request = adx.data.models.QueryRequest();
            queryStr = sprintf('%s | take  100', tableName);
            request.csl = queryStr;
            % Create the Query object and run the request
            query = adx.data.api.Query();
            [code, resultRaw, response, id] = query.queryRun(request, apiVersion="v2", skipResponseDecode=true); %#ok<ASGLU>
            testCase.verifyClass(id, "string");
            testCase.verifyEqual(code, matlab.net.http.StatusCode.OK);
            testCase.verifyEmpty(resultRaw);
            testCase.verifyClass(resultRaw, "adx.data.models.QueryV2ResponseRaw");
        end


        function testRandomDataV1skipResponseDecode(testCase)
            disp("Running testRandomDataV1skipResponseDecode");
            tableName = "RandomData";
            request = adx.data.models.QueryRequest();
            queryStr = sprintf('%s | take  100', tableName);
            request.csl = queryStr;
            % Create the Query object and run the request
            query = adx.data.api.Query();
            [code, resultRaw, response, id] = query.queryRun(request, apiVersion="v1", skipResponseDecode=true); %#ok<ASGLU>
            testCase.verifyClass(id, "string");
            testCase.verifyEqual(code, matlab.net.http.StatusCode.OK);
            testCase.verifyEmpty(resultRaw);
            testCase.verifyClass(resultRaw, "adx.data.models.QueryV1ResponseRaw");
        end


        function testRandomDataV2skipRowsArrayDecode(testCase)
            disp("Running testRandomDataV2skipRowsArrayDecode");
            tableName = "RandomData";
            request = adx.data.models.QueryRequest();
            queryStr = sprintf('%s | take  100', tableName);
            request.csl = queryStr;
            % Create the Query object and run the request
            query = adx.data.api.Query();
            [code, resultRaw, response, id] = query.queryRun(request, apiVersion="v2", skipRowsArrayDecode=true); %#ok<ASGLU>
            testCase.verifyClass(id, "string");
            testCase.verifyEqual(code, matlab.net.http.StatusCode.OK);
            testCase.verifyClass(resultRaw, "adx.data.models.QueryV2ResponseUnparsedRows");
            testCase.verifyEqual(resultRaw(3).TableName, "PrimaryResult");
            testCase.verifyEqual(numel(resultRaw(3).Rows), 1);
        end


        % Disable long running test
        % function testReadAll(testCase)
        %     disp("testReadAll");
        %     [tableNames, success, ~] = mathworks.adx.listTables(database="unittestdb");
        %     testCase.verifyTrue(success);
        %     for n = 1:numel(tableNames)
        %         fprintf("Reading: %s\n",tableNames(n));
        %         query = sprintf('table("%s", "all")', tableNames(n));
        %         [result, success] = mathworks.adx.run(query, nullPolicy=mathworks.adx.NullPolicy.AllowAll, useParallel=true, verbose=true); %#ok<ASGLU>
        %         testCase.verifyTrue(success);
        %         testCase.verifyTrue(istable(result));
        %         fprintf("Rows: %d\n", height(result));
        %     end
        % end

        % function testAsync1(testCase)
        %     disp("Running testRandomDataV1");
        %     tableName = "RandomData";
        %     query = sprintf('%s | take  1000', tableName);
        %     % Create the Query object and run the request
        %     args = {"propertyNames", "async", "propertyValues", {true}, "verbose", true};
        %     [result, success, requestId, resultTables, dataSetHeader, dataSetCompletion] = mathworks.adx.KQLQuery(query, "verbose", true); %#ok<ASGLU>
        % 
        %     [code, resultRaw, response] = query.queryRun(request, apiVersion="v1"); %#ok<ASGLU>
        %     testCase.verifyEqual(code, matlab.net.http.StatusCode.OK);
        %     % Convert the response to Tables
        %     [result, ~] = mathworks.internal.adx.queryV1Response2Tables(resultRaw);
        %     % Non progressive v2 version
        %     [npResult, success, requestId, resultTables, dataSetHeader, dataSetCompletion] = mathworks.adx.run(queryStr); %#ok<ASGLU>
        %     testCase.verifyTrue(success);
        %     % Does progressive and non progressive give the same table 
        %     testCase.verifyEqual(result, npResult);
        % end
    end
end