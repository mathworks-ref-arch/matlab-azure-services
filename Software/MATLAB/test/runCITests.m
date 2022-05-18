function runCITests(name)
    import matlab.unittest.TestRunner;
    import matlab.unittest.Verbosity;
    import matlab.unittest.plugins.XMLPlugin;
    import matlab.unittest.selectors.HasName;
    import matlab.unittest.constraints.StartsWithSubstring;
    
    if nargin==0
        name = ['R' version('-release')];
    end

    % Generate a suite with all tests
    suite = matlab.unittest.TestSuite.fromFolder('unit','IncludingSubfolders',true);

    % Configure for JUnit XML reporting
    [~,~] = mkdir('../../../test-results');

    runner = TestRunner.withTextOutput('OutputDetail', Verbosity.Detailed);
    runner.addPlugin(XMLPlugin.producingJUnitFormat(['../../../test-results/' name '.xml']));

    % Run the suite
    results = runner.run(suite);

    % Assert that none of the tests failed
    nfailed = nnz([results.Failed]);
    assert(nfailed == 0, [num2str(nfailed) ' test(s) failed.']);
    