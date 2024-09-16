classdef (SharedTestFixtures={adxFixture}) testCustomDecoder < matlab.unittest.TestCase
    % testCmds Unit testing for high level commands

    %  (c) 2024 MathWorks, Inc.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add your test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        clusterName string
        cluster adx.control.models.Cluster
        state adx.control.models.ClusterProperties_1StateEnum
        Database = "unittestdb"
    end

    methods (TestClassSetup)
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
        function testCRD(testCase)
            disp("Running testCRD");
            usePCT = getenv('USEPCT');
            if strcmp(usePCT, 'FALSE')
                disp("Not using PCT skipping testCRD");
            else
                tableName = "exampleCRD";
                matFile = mathworks.adx.adxRoot("test", "unit", "Adx", "fixtures",  "crdTable.mat");
                testCase.verifyTrue(isfile(matFile));
                load(matFile, "crdTable");
                if ~mathworks.adx.tableExists(tableName, database=testCase.Database)
                    % Regenerate an exampleCRD table if required
                    % nrows = 60000;
                    % intCol = int64(randi(intmax('int32'), nrows, 1, "int32"));
                    % doubleCol = zeros(nrows, 1);
                    % stringCol = strings(nrows, 1);
                    % for n = 1:nrows
                    %     doubleCol(n) = double(n);
                    %     stringCol(n) = "myStringValue-" + num2str(n);
                    % end
                    % variableNames = ["intCol", "doubleCol", "stringCol"];
                    % crdTable = table(intCol, doubleCol, stringCol);
                    % crdTable.Properties.VariableNames=variableNames;
                    [ingestTf, ingestResult] =  mathworks.adx.ingestTable(crdTable, tableName=tableName, mode="drop", database=testCase.Database); %#ok<ASGLU>
                    testCase.verifyTrue(ingestTf);
                else
                    fprintf("Existing table found: %s\n", tableName);
                end

                query = sprintf('table("%s", "all")', tableName);
                crd = @mathworks.internal.adx.exampleCustomRowDecoder;

                [readBackResult, success] = mathworks.adx.run(query, useParallel=true, customRowDecoder=crd, verbose=true);
                testCase.verifyTrue(success);
                testCase.verifyEqual(readBackResult.intCol(1), crdTable.intCol(1));
                testCase.verifyEqual(readBackResult.doubleCol(1), crdTable.doubleCol(1));
                testCase.verifyEqual(readBackResult.stringCol(1), crdTable.stringCol(1));
                testCase.verifyEqual(readBackResult.intCol(end), crdTable.intCol(end));
                testCase.verifyEqual(readBackResult.doubleCol(end), crdTable.doubleCol(end));
                testCase.verifyEqual(readBackResult.stringCol(end), crdTable.stringCol(end));
            end
        end 

        function testCRDParallel(testCase)
            disp("Running testCRDParallel");
            usePCT = getenv('USEPCT');
            if strcmp(usePCT, 'FALSE')
                disp("Not using PCT skipping testCRDParallel");
            else
                tableName = "exampleCRD";
                matFile = mathworks.adx.adxRoot("test", "unit", "Adx", "fixtures",  "crdTable.mat");
                testCase.verifyTrue(isfile(matFile));
                load(matFile, "crdTable");
                if ~mathworks.adx.tableExists(tableName, database=testCase.Database)
                    [ingestTf, ingestResult] = mathworks.adx.ingestTable(crdTable, tableName=tableName, mode="drop", database=testCase.Database); %#ok<ASGLU>
                    testCase.verifyTrue(ingestTf);
                else
                    fprintf("Existing table found: %s\n", tableName);
                end

                query = sprintf('table("%s", "all")', tableName);
                crd = @mathworks.internal.adx.exampleCustomRowDecoder;
                [readBackResult, success] = mathworks.adx.run(query, customRowDecoder=crd, useParallel=true);
                testCase.verifyTrue(success);
                testCase.verifyEqual(readBackResult.intCol(1), crdTable.intCol(1));
                testCase.verifyEqual(readBackResult.doubleCol(1), crdTable.doubleCol(1));
                testCase.verifyEqual(readBackResult.stringCol(1), crdTable.stringCol(1));
                testCase.verifyEqual(readBackResult.intCol(end), crdTable.intCol(end));
                testCase.verifyEqual(readBackResult.doubleCol(end), crdTable.doubleCol(end));
                testCase.verifyEqual(readBackResult.stringCol(end), crdTable.stringCol(end));
            end
        end




        function testCRDProgressiveParallel(testCase)
            disp("Running testCRDProgressiveParallel");
            usePCT = getenv('USEPCT');
            
            tableName = "exampleCRD";
            matFile = mathworks.adx.adxRoot("test", "unit", "Adx", "fixtures",  "crdTable.mat");
            load(matFile, "crdTable");
            testCase.verifyTrue(isfile(matFile));
            if ~mathworks.adx.tableExists(tableName, database=testCase.Database)
                [ingestTf, ingestResult] =  mathworks.adx.ingestTable(crdTable, tableName=tableName, mode="drop", database=testCase.Database); %#ok<ASGLU>
                testCase.verifyTrue(ingestTf);
            else
                fprintf("Existing table found: %s\n", tableName);
            end
            
            query = sprintf('table("%s", "all")', tableName);
            crd = @mathworks.internal.adx.exampleCustomRowDecoder;
            
            if strcmp(usePCT, 'FALSE')
                disp("Not using PCT skipping part of testCRDProgressiveParallel");
            else
                args = {"customRowDecoder", crd, "propertyNames", "results_progressive_enabled", "propertyValues", {true},...
                    "verbose", true, "useParallel", true, "parallelThreshold", 500};
                [readBackResult, success] = mathworks.adx.run(query, args{:});

                testCase.verifyTrue(success);
                testCase.verifyEqual(readBackResult.intCol(1), crdTable.intCol(1));
                testCase.verifyEqual(readBackResult.doubleCol(1), crdTable.doubleCol(1));
                testCase.verifyEqual(readBackResult.stringCol(1), crdTable.stringCol(1));
                testCase.verifyEqual(readBackResult.intCol(end), crdTable.intCol(end));
                testCase.verifyEqual(readBackResult.doubleCol(end), crdTable.doubleCol(end));
                testCase.verifyEqual(readBackResult.stringCol(end), crdTable.stringCol(end));
            end

            % Non progressive non parallel version
            [npResult, success, requestId, resultTables, dataSetHeader, dataSetCompletion] = mathworks.adx.run(query, verbose=true); %#ok<ASGLU>
            testCase.verifyTrue(success);
            if ~strcmp(usePCT, 'FALSE')
                % Does progressive and non progressive give the same table 
                testCase.verifyEqual(readBackResult, npResult);
            end
        end
    end
end