classdef testMapTypesKustoToMATLAB < matlab.unittest.TestCase
    % testMapTypesKustoToMATLAB Unit testing for Kusto to MATLAB type mapping

    %  (c) 2026 MathWorks, Inc.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add your test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties (TestParameter)
        supportedMappingCase = struct( ...
            'intType', struct('inputType', "int", 'expectedType', "int32"), ...
            'longType', struct('inputType', "long", 'expectedType', "int64"), ...
            'stringType', struct('inputType', "string", 'expectedType', "string"), ...
            'guidType', struct('inputType', "guid", 'expectedType', "string"), ...
            'realType', struct('inputType', "real", 'expectedType', "double"), ...
            'datetimeType', struct('inputType', "datetime", 'expectedType', "datetime"), ...
            'dynamicType', struct('inputType', "dynamic", 'expectedType', "cell"), ...
            'boolType', struct('inputType', "bool", 'expectedType', "logical"), ...
            'timespanType', struct('inputType', "timespan", 'expectedType', "duration"), ...
            'decimalType', struct('inputType', "decimal", 'expectedType', "double"), ...
            'charVectorInput', struct('inputType', 'long', 'expectedType', "int64"));
        caseInsensitiveCase = struct( ...
            'mixedCaseInt', struct('inputType', "InT", 'expectedType', "int32"), ...
            'mixedCaseGuid', struct('inputType', "GuId", 'expectedType', "string"), ...
            'mixedCaseDynamic', struct('inputType', "DyNaMiC", 'expectedType', "cell"), ...
            'mixedCaseTimespan', struct('inputType', "TiMeSpAn", 'expectedType', "duration"));
    end

    methods (TestClassSetup)
        function addSourceToPath(testCase)
            testFolder = fileparts(mfilename('fullpath'));
            matlabRoot = fileparts(fileparts(fileparts(testFolder)));
            sourceFolder = fullfile(matlabRoot, 'app', 'system');

            testCase.applyFixture(matlab.unittest.fixtures.PathFixture(sourceFolder));
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
        function testSupportedTypeMappings(testCase, supportedMappingCase)
            actualType = mathworks.internal.adx.mapTypesKustoToMATLAB( ...
                supportedMappingCase.inputType);

            testCase.verifyEqual(actualType, supportedMappingCase.expectedType);
        end

        function testTypeMappingsAreCaseInsensitive(testCase, caseInsensitiveCase)
            actualType = mathworks.internal.adx.mapTypesKustoToMATLAB( ...
                caseInsensitiveCase.inputType);

            testCase.verifyEqual(actualType, caseInsensitiveCase.expectedType);
        end

        function testUnsupportedTypeWarnsAndFallsBackToString(testCase)
            actualType = testCase.verifyWarning( ...
                @() mathworks.internal.adx.mapTypesKustoToMATLAB("uuid"), ...
                "adx:mapTypesKustoToMATLAB");

            testCase.verifyEqual(actualType, "string");
        end

        function testRejectsEmptyStringInput(testCase)
            testCase.verifyError( ...
                @() mathworks.internal.adx.mapTypesKustoToMATLAB(""), ...
                "MATLAB:validators:mustBeNonzeroLengthText");
        end

        function testRejectsNonScalarStringInput(testCase)
            testCase.verifyError( ...
                @() mathworks.internal.adx.mapTypesKustoToMATLAB(["int", "long"]), ...
                "MATLAB:validators:mustBeTextScalar");
        end
    end
end
