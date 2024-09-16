classdef (SharedTestFixtures={adxFixture}) testCluster < matlab.unittest.TestCase
    % TESTCLUSTER Unit testing for the cluster API
    
    %  (c) 2023 MathWorks, Inc.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add your test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        clusterName string 
        cluster adx.control.models.Cluster
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
            state = testCase.cluster.xproperties.state;
            testCase.verifyClass(state, 'adx.control.models.ClusterProperties_1StateEnum');
            testCase.verifyEqual(state, adx.control.models.ClusterProperties_1StateEnum.Running);

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
        function testClustersList(testCase)
            disp("Running testClustersList");
            c = adx.control.api.Clusters;
            [code, result, response] = c.clustersList(c.subscriptionId, c.apiVersion); %#ok<ASGLU>
            testCase.verifyEqual(code, matlab.net.http.StatusCode.OK);
            testCase.verifyClass(result,'adx.control.models.ClusterListResult');
            testCase.verifyTrue(isprop(result, 'value'));
            % The testCase cluster at least should be listed
            testCase.verifyGreaterThanOrEqual(numel(result.value), 1);
        end
    end
end