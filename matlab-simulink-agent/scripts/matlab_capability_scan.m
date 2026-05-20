function matlab_capability_scan(outputFile)
%MATLAB_CAPABILITY_SCAN Write installed MATLAB capabilities to JSON.
%   matlab_capability_scan("matlab-capabilities.json")

if nargin < 1 || strlength(string(outputFile)) == 0
    outputFile = 'matlab-capabilities.json';
end
outputFile = char(string(outputFile));

report = struct();
report.generatedAt = char(datetime('now', 'TimeZone', 'local', 'Format', 'yyyy-MM-dd HH:mm:ss Z'));
report.version = version;
report.release = version('-release');
report.matlabroot = matlabroot;
report.platform = computer;
report.products = productList();
report.helpIndexes = helpIndexes();
report.simulink = simulinkStatus();

json = jsonencode(report, 'PrettyPrint', true);
fid = fopen(outputFile, 'w');
if fid < 0
    error('matlab_capability_scan:OpenFailed', 'Could not open output file: %s', outputFile);
end
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, '%s\n', json);
fprintf('Wrote capability scan: %s\n', outputFile);
end

function products = productList()
v = ver;
products = repmat(struct('name', '', 'version', '', 'release', '', 'date', ''), 0, 1);
for k = 1:numel(v)
    products(k).name = v(k).Name; %#ok<AGROW>
    products(k).version = v(k).Version;
    products(k).release = v(k).Release;
    products(k).date = v(k).Date;
end
end

function indexes = helpIndexes()
files = dir(fullfile(matlabroot, 'help', '**', 'helpfuncbycat.xml'));
indexes = strings(numel(files), 1);
for k = 1:numel(files)
    indexes(k) = string(fullfile(files(k).folder, files(k).name));
end
end

function status = simulinkStatus()
status = struct();
status.whichSim = safeWhich('sim');
status.whichNewSystem = safeWhich('new_system');
status.whichFindSystem = safeWhich('find_system');
status.available = ~isempty(status.whichSim) && ~strcmp(status.whichSim, '(not found)');

if status.available
    try
        load_system('simulink');
        status.simulinkLoaded = true;
        blocks = find_system('simulink', 'SearchDepth', 2, 'Type', 'Block');
        status.topLevelBlockCount = numel(blocks);
    catch ME
        status.simulinkLoaded = false;
        status.loadError = ME.message;
    end
else
    status.simulinkLoaded = false;
end
end

function result = safeWhich(topic)
try
    result = which(topic);
    if isempty(result)
        result = '(not found)';
    end
catch ME
    result = sprintf('(which failed: %s)', ME.message);
end
end
