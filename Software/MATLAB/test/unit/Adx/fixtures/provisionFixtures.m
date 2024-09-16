% Script to put some sample data files in place

% Run in the test/unit/fixtures directory
cd(mathworks.adx.adxRoot("test", "unit", "Adx", "fixtures"));

% Get outages.parquet from MATLAB install
outagesPath = fullfile(matlabroot, "toolbox", "matlab", "demos", "outages.parquet");
if ~isfile(outagesPath)
    error("File not found: %s", outagesPath);
else
    dstPath = mathworks.adx.adxRoot("test", "unit", "Adx", "fixtures", "outages.parquet");
    if isfile(dstPath)
        fprintf("File already exists: %s\n", dstPath);
    else
        [status, msg] = copyfile(outagesPath, dstPath);
        if status == 1
            fprintf("Saved: %s\n", dstPath)
        else
            fprintf("Copy failed, destination: %s, Message: %s\n", dstPath, msg);
        end
    end
end

% Download a sample file with many edge cases
dstPath = mathworks.adx.adxRoot("test", "unit", "Adx", "fixtures", "random-data-license.txt");
if isfile(dstPath)
    fprintf("File already exists: %s\n", dstPath);
else
    result = websave("random-data-license.txt", "https://raw.githubusercontent.com/ag-ramachandran/random-json-data-types/main/LICENSE");
    fprintf("Saved: %s\n", result);
end

dstPath = mathworks.adx.adxRoot("test", "unit", "Adx", "fixtures", "random-data.json");
if isfile(dstPath)
    fprintf("File already exists: %s\n", dstPath);
else
    result = websave("random-data.json", "https://raw.githubusercontent.com/ag-ramachandran/random-json-data-types/main/random-data.json");
    fprintf("Saved: %s\n", result);
end

% Airline small  WIP
airlinesmallPath = fullfile(matlabroot, "toolbox", "matlab", "demos", "airlinesmall.parquet");
if ~isfile(airlinesmallPath)
    error("File not found: %s", airlinesmallPath);
end

%% TODO create a database and table and populate it with airlinesamll

% Automatically created mapping command
% .create table ['airlinesmall'] ingestion parquet mapping 'airlinesmall_mapping' '[{"column":"Date", "Properties":{"Path":"$[\'Date\']"}},{"column":"DayOfWeek", "Properties":{"Path":"$[\'DayOfWeek\']"}},{"column":"DepTime", "Properties":{"Path":"$[\'DepTime\']"}},{"column":"CRSDepTime", "Properties":{"Path":"$[\'CRSDepTime\']"}},{"column":"ArrTime", "Properties":{"Path":"$[\'ArrTime\']"}},{"column":"CRSArrTime", "Properties":{"Path":"$[\'CRSArrTime\']"}},{"column":"UniqueCarrier", "Properties":{"Path":"$[\'UniqueCarrier\']"}},{"column":"FlightNum", "Properties":{"Path":"$[\'FlightNum\']"}},{"column":"TailNum", "Properties":{"Path":"$[\'TailNum\']"}},{"column":"ActualElapsedTime", "Properties":{"Path":"$[\'ActualElapsedTime\']"}},{"column":"CRSElapsedTime", "Properties":{"Path":"$[\'CRSElapsedTime\']"}},{"column":"AirTime", "Properties":{"Path":"$[\'AirTime\']"}},{"column":"ArrDelay", "Properties":{"Path":"$[\'ArrDelay\']"}},{"column":"DepDelay", "Properties":{"Path":"$[\'DepDelay\']"}},{"column":"Origin", "Properties":{"Path":"$[\'Origin\']"}},{"column":"Dest", "Properties":{"Path":"$[\'Dest\']"}},{"column":"Distance", "Properties":{"Path":"$[\'Distance\']"}},{"column":"TaxiIn", "Properties":{"Path":"$[\'TaxiIn\']"}},{"column":"TaxiOut", "Properties":{"Path":"$[\'TaxiOut\']"}},{"column":"Cancelled", "Properties":{"Path":"$[\'Cancelled\']"}},{"column":"CancellationCode", "Properties":{"Path":"$[\'CancellationCode\']"}},{"column":"Diverted", "Properties":{"Path":"$[\'Diverted\']"}},{"column":"CarrierDelay", "Properties":{"Path":"$[\'CarrierDelay\']"}},{"column":"WeatherDelay", "Properties":{"Path":"$[\'WeatherDelay\']"}},{"column":"NASDelay", "Properties":{"Path":"$[\'NASDelay\']"}},{"column":"SecurityDelay", "Properties":{"Path":"$[\'SecurityDelay\']"}},{"column":"LateAircraftDelay", "Properties":{"Path":"$[\'LateAircraftDelay\']"}}]'
%