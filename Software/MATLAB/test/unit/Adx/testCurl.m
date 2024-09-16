classdef (SharedTestFixtures={adxFixture}) testCurl < matlab.unittest.TestCase
    % testCurl Unit testing for high level commands

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
        function testadxCurlWriteDefault(testCase)
            disp("Running testadxCurlWriteDefault");
            [tf, result, id] = mathworks.internal.curl.adxCurlWrite();
            testCase.verifyTrue(tf);
            testCase.verifyTrue(isstring(id));
            testCase.verifyTrue(isstruct(result));
            testCase.verifyTrue(isfield(result, "Tables"));
            testCase.verifyEqual(numel(result.Tables), 4);
            testCase.verifyTrue(isfield(result.Tables(4), "TableName"));
            testCase.verifyEqual(result.Tables(4).TableName, 'Table_3');
            testCase.verifyEqual(result.Tables(1).Rows{1}{:}, 'Hello World');
        end

    end
end