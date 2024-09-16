classdef (SharedTestFixtures={adxFixture}) testCmds < matlab.unittest.TestCase
    % testCmds Unit testing for high level commands

    %  (c) 2024 MathWorks, Inc.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add your test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        clusterName string
        cluster adx.control.models.Cluster
        state adx.control.models.ClusterProperties_1StateEnum
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
        function testListTables(testCase)
            disp("Running testListTables");
            [tableNames, success, tableDetails] = mathworks.adx.listTables(database="unittestdb");
            testCase.verifyTrue(success);
            testCase.verifyTrue(istable(tableDetails));
            testCase.verifyTrue(isstring(tableNames));
            testCase.verifyTrue(any(contains(tableNames, "outage")));
            testCase.verifyTrue(any(contains(tableNames, "airlinesmall")));
        end


        function testTableExists(testCase)
            disp("Running testTableExists");
            tf = mathworks.adx.tableExists("outages", database="unittestdb");
            testCase.verifyTrue(tf);
            tf = mathworks.adx.tableExists("NotATable", database="unittestdb");
            testCase.verifyFalse(tf);
        end


        function testDropTable(testCase)
            disp("Running testDropTable");
            % drop a table that does not exist
            tf = mathworks.adx.tableExists("NotATable", database="unittestdb");
            testCase.verifyFalse(tf);
            disp("Error message expected:")
            result = mathworks.adx.dropTable("NotATable", database="unittestdb");
            testCase.verifyClass(result, "adx.control.models.ErrorResponse");
            testCase.verifyEqual(result.error.code, "BadRequest_EntityNotFound");

            % drop a table that does exist
            matlabTable = table("abc", 123, true);
            if mathworks.adx.tableExists("tempTable", database="unittestdb")
                result = mathworks.adx.dropTable("tempTable", database="unittestdb");
                testCase.verifyTrue(istable(result));
                testCase.verifyFalse(any(contains(result.TableName, "tempTable")));
            end
            
            [tf, result] = mathworks.adx.createTable(matlabTable, "tempTable", database="unittestdb");
            testCase.verifyTrue(tf);
            testCase.verifyTrue(istable(result));
            testCase.verifyEqual(result.TableName, "tempTable");
            result = mathworks.adx.dropTable("tempTable", database="unittestdb");
            testCase.verifyTrue(istable(result));
            testCase.verifyFalse(any(contains(result.TableName, "tempTable")));
        end
    end
end