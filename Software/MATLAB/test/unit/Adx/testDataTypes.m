classdef (SharedTestFixtures={adxFixture}) testDataTypes < matlab.unittest.TestCase
    % testDataTypes Unit testing for data type conversion

    %  (c) 2024 MathWorks, Inc.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add your test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
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
        function readTables(testCase)
            % 123523 rows so takes a while to convert
            % [result, success, requestId, resultTables, dataSetHeader, dataSetCompletion] = mathworks.adx.run('table("airlinesmall", "all")', nullPolicy=mathworks.adx.NullPolicy.AllowAll) %#ok<ASGLU>
            % testCase.verifyTrue(success);
            % testCase.verifyEqual(height(result), 123523);

            [result, success, requestId, resultTables, dataSetHeader, dataSetCompletion] = mathworks.adx.run('["airlinesmall"] | take 1000', nullPolicy=mathworks.adx.NullPolicy.AllowAll); %#ok<ASGLU>
            testCase.verifyTrue(success);
            testCase.verifyEqual(height(result), 1000);
            
            [result, success, requestId, resultTables, dataSetHeader, dataSetCompletion] = mathworks.adx.run('table("outages", "all")'); %#ok<ASGLU>
            testCase.verifyTrue(success);
            testCase.verifyGreaterThanOrEqual(height(result), 1468);
        end

        function testDuration(testCase)
            %                1     2       3      4      5       6            7            8            9             10            11
            timespanStr = ["2d", "1.5h", "30m", "10s", "0.1s", "100ms", "10microsecond", "1tick" "time(15 seconds)", "time(2)", "time(0.12:34:56.7)"];
            expectedDurations = duration.empty;
            expectedDurations(1) = days(2);
            expectedDurations(2) = hours(1.5);
            expectedDurations(3) = minutes(30);
            expectedDurations(4) = seconds(10);
            expectedDurations(5) = seconds(0.1);
            %                               h m s ms
            expectedDurations(6) = duration(0,0,0,100);
            %                                d h m s 10microsecond
            expectedDurations(7) = duration("0:0:0:0.000010", 'InputFormat', "dd:hh:mm:ss.SSSSSS", 'Format', "dd:hh:mm:ss.SSSSSS");
            %                                d h m s 1tick / 100 ns
            expectedDurations(8) = duration("0:0:0:0.0000001", 'InputFormat', "dd:hh:mm:ss.SSSSSSS", 'Format', "dd:hh:mm:ss.SSSSSSS");
            expectedDurations(9) = seconds(15);
            expectedDurations(10) = days(2);
            expectedDurations(11) = duration("0:12:34:56.7", InputFormat="dd:hh:mm:ss.S");

            testCase.verifyEqual(numel(timespanStr), numel(expectedDurations));

            for n = 1:numel(timespanStr)
                testCase.verifyEqual(mathworks.internal.adx.timespanLiteral2duration(timespanStr(n)), expectedDurations(n));
            end
        end


        function testTimespanLiterals(testCase)
            disp("Running testTimespanLiterals");

            [result, success, requestId] = mathworks.adx.run('.drop table timespanTests ifexists'); %#ok<ASGLU>
            testCase.verifyClass(requestId, "string");
            testCase.verifyGreaterThan(strlength(requestId), 0);
            testCase.verifyTrue(success);

            %cmd = '.create table timespanTests ( daysC:timespan, hoursC:timespan, minutesC:timespan, seconds10:timespan, seconds01:timespan, duration100ms:timespan, duration10us:timespan, tick1C:timespan, time15s:timespan, time2:timespan, timeStr:timespan )';
            cmd = '.create table timespanTests ( daysC:timespan)';
            [result, success, requestId] = mathworks.adx.run(cmd); 
            testCase.verifyTrue(success);
            testCase.verifyClass(requestId, "string");
            testCase.verifyGreaterThan(strlength(requestId), 0);
            testCase.verifyEqual(result.TableName, "timespanTests");
            testCase.verifyEqual(height(result), 1);
            testCase.verifyEqual(width(result), 5);
            testCase.verifyTrue(startsWith(result.Schema, '{"Name":"timespanTests","OrderedColumns":[{"Name":"daysC","Type":'));

            [result, success, requestId] = mathworks.adx.run('.show table timespanTests cslschema');
            testCase.verifyTrue(success);
            testCase.verifyClass(requestId, "string");
            testCase.verifyGreaterThan(strlength(requestId), 0);
            testCase.verifyEqual(result.TableName, "timespanTests");
            testCase.verifyEqual(height(result), 1);
            testCase.verifyEqual(width(result), 5);
            %testCase.verifyTrue(startsWith(result.Schema, 'daysC:timespan,hoursC:timespan,minutesC:timespan,seconds10:timespan,seconds01:timespan'));
            testCase.verifyTrue(startsWith(result.Schema, 'daysC:timespan'));
            
            [result, success, requestId] = mathworks.adx.run('.ingest inline into table timespanTests <| "2d"'); %#ok<ASGLU>
            testCase.verifyTrue(success);
            testCase.verifyClass(requestId, "string");
            testCase.verifyGreaterThan(strlength(requestId), 0);

            [result, success, requestId] = mathworks.adx.run('timespanTests | take 5'); %#ok<ASGLU>
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.daysC, days(2));
        end


        function testDynamic(testCase)
            % TODO create a comparable data set
            % [result, success, requestId] = mathworks.adx.run('capability | take 5'); %#ok<ASGLU>
            % testCase.verifyTrue(success);

            % conversion to literal in query
            [result, success] = mathworks.adx.run('print d=dynamic({"a": datetime(1970-05-11)})');
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.d{1}.a, '1970-05-11T00:00:00.0000000Z');
            
            % just return the json
            [result, success] = mathworks.adx.run('print d=dynamic({"a": datetime(1970-05-11)})', convertDynamics=false);
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.d{1}, '{"a":"1970-05-11T00:00:00.0000000Z"}');

            [result, success] = mathworks.adx.run('print o=dynamic({"a":123, "b":"hello", "c":[1,2,3], "d":{}})');
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.o{1}.a, 123);
            testCase.verifyEqual(result.o{1}.b, 'hello');
            testCase.verifyEqual(result.o{1}.c, [1,2,3]');
            testCase.verifyTrue(isstruct(result.o{1}.d));
            testCase.verifyTrue(isempty(fieldnames(result.o{1}.d)));

            % null
            [result, success] = mathworks.adx.run('print d=dynamic(null)');
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.d{1}, missing);

            % primitive
            [result, success] = mathworks.adx.run('print d=dynamic(4)');
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.d{1}, 4);

            % array of literals
            [result, success] = mathworks.adx.run('print d=dynamic([1, 2, "hello"])');
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.d{1}{1}, 1);
            testCase.verifyEqual(result.d{1}{2}, 2);
            testCase.verifyEqual(result.d{1}{3}, 'hello');

            % dynamic({"a":1, "b":{"a":2}}) is a property bag with two slots, a, and b, with the second slot being another property bag
            [result, success] = mathworks.adx.run('print d=dynamic({"a":1, "b":{"a":2}})');
            testCase.verifyTrue(success);
            testCase.verifyTrue(isstruct(result.d{1}));
            testCase.verifyEqual(result.d{1}.a, 1);
            testCase.verifyEqual(result.d{1}.b.a, 2);

            % parse a string value that follows the JSON encoding rules into a dynamic value, use the parse_json function
            [result, success] = mathworks.adx.run("print d=parse_json('[43, 21, 65]')");
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.d{1}, [43,21,65]');

            [result, success] = mathworks.adx.run('print d=parse_json(''{"name":"Alan", "age":21, "address":{"street":432,"postcode":"JLK32P"}}'')');
            testCase.verifyTrue(success);
            testCase.verifyTrue(isstruct(result.d{1}));
            testCase.verifyEqual(result.d{1}.name, 'Alan');
            testCase.verifyEqual(result.d{1}.age, 21);
            testCase.verifyEqual(result.d{1}.address.street, 432);
            testCase.verifyEqual(result.d{1}.address.postcode, 'JLK32P');

            [result, success] = mathworks.adx.run("print d=parse_json('21')");
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.d{1}, 21);

            [result, success] = mathworks.adx.run("print d=parse_json('21')", convertDynamics=false);
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.d{1}, '21');

            [result, success] = mathworks.adx.run('print d=parse_json(''"21"'')');
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.d{1}, '21');

            [result, success] = mathworks.adx.run('print d=parse_json(''"21"'')', convertDynamics=false);
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.d{1}, '21');
        end


        function testNulls(testCase)
            % bool
            T = @() mathworks.adx.run('print bool(null)');
            testCase.verifyError(T, "adx:getRowsWithSchema");
             
            [result, success] = mathworks.adx.run('print bool(null)', nullPolicy=mathworks.adx.NullPolicy.AllowAll);
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.print_0(1), {missing});

            [result, success] = mathworks.adx.run('print bool(null)', nullPolicy=mathworks.adx.NullPolicy.Convert2Double);
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.print_0(1), NaN);
             
            % double
            [result, success] = mathworks.adx.run('print double(null)', nullPolicy=mathworks.adx.NullPolicy.AllowAll);
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.print_0(1), NaN);
             
            [result, success] = mathworks.adx.run('print double(null)');
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.print_0(1), NaN);

            % datetime
            [result, success] = mathworks.adx.run('print datetime(null)', nullPolicy=mathworks.adx.NullPolicy.AllowAll);
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.print_0(1), datetime(NaT, "TimeZone", "UTC"));
             
            [result, success] = mathworks.adx.run('print datetime(null)');
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.print_0(1), datetime(NaT, "TimeZone", "UTC"));

            % dynamic
            [result, success] = mathworks.adx.run('print dynamic(null)', nullPolicy=mathworks.adx.NullPolicy.AllowAll);
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.print_0(1), {missing});
             
            [result, success] = mathworks.adx.run('print dynamic(null)');
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.print_0(1), {missing});

            % guid
            [result, success] = mathworks.adx.run('print guid(null)', nullPolicy=mathworks.adx.NullPolicy.AllowAll);
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.print_0(1), missing);
             
            [result, success] = mathworks.adx.run('print guid(null)');
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.print_0(1), missing);

            % int
            T = @() mathworks.adx.run('print int(null)');
            testCase.verifyError(T, "adx:getRowsWithSchema");
             
            [result, success] = mathworks.adx.run('print int(null)', nullPolicy=mathworks.adx.NullPolicy.AllowAll);
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.print_0(1), {missing});

            [result, success] = mathworks.adx.run('print int(null)', nullPolicy=mathworks.adx.NullPolicy.Convert2Double);
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.print_0(1), NaN);

            % long
            T = @() mathworks.adx.run('print long(null)');
            testCase.verifyError(T, "adx:getRowsWithSchema");
             
            [result, success] = mathworks.adx.run('print long(null)', nullPolicy=mathworks.adx.NullPolicy.AllowAll);
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.print_0(1), {missing});

            [result, success] = mathworks.adx.run('print long(null)', nullPolicy=mathworks.adx.NullPolicy.Convert2Double);
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.print_0(1), NaN);

            % real
            [result, success] = mathworks.adx.run('print real(null)', nullPolicy=mathworks.adx.NullPolicy.AllowAll);
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.print_0(1), NaN);
             
            [result, success] = mathworks.adx.run('print real(null)');
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.print_0(1), NaN);

            % time
            durationNaN = duration(nan,nan,nan);
            [result, success] = mathworks.adx.run('print time(null)', nullPolicy=mathworks.adx.NullPolicy.AllowAll);
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.print_0(1), durationNaN);
             
            [result, success] = mathworks.adx.run('print time(null)');
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.print_0(1), durationNaN);
        end


        function testVals(testCase)           
            [result, success] = mathworks.adx.run('print bool(true)', nullPolicy=mathworks.adx.NullPolicy.AllowAll);
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.print_0(1), {true});

            [result, success] = mathworks.adx.run('print bool(true)');
            testCase.verifyTrue(success);
            testCase.verifyEqual(result.print_0(1), true);
        end
    end
end
