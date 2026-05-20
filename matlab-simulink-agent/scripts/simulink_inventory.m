function simulink_inventory(outputFile, libraries, searchDepth)
%SIMULINK_INVENTORY Export Simulink library block metadata to JSON.
%   simulink_inventory("simulink-inventory.json")
%   simulink_inventory("inventory.json", ["simulink"], 4)

if nargin < 1 || strlength(string(outputFile)) == 0
    outputFile = 'simulink-inventory.json';
end
outputFile = char(string(outputFile));

if nargin < 2 || isempty(libraries)
    libraries = "simulink";
end
libraries = string(libraries);

if nargin < 3 || isempty(searchDepth)
    searchDepth = 4;
end

report = struct();
report.generatedAt = char(datetime('now', 'TimeZone', 'local', 'Format', 'yyyy-MM-dd HH:mm:ss Z'));
report.version = version;
report.libraries = repmat(struct('name', '', 'loaded', false, 'error', '', 'blocks', []), 0, 1);

for k = 1:numel(libraries)
    libName = char(libraries(k));
    entry = struct('name', libName, 'loaded', false, 'error', '', 'blocks', []);
    try
        load_system(libName);
        entry.loaded = true;
        blockPaths = find_system(libName, 'LookUnderMasks', 'all', ...
            'FollowLinks', 'on', 'SearchDepth', searchDepth, 'Type', 'Block');
        entry.blocks = collectBlocks(blockPaths);
    catch ME
        entry.error = ME.message;
    end
    report.libraries(end + 1) = entry; %#ok<AGROW>
end

json = jsonencode(report, 'PrettyPrint', true);
fid = fopen(outputFile, 'w');
if fid < 0
    error('simulink_inventory:OpenFailed', 'Could not open output file: %s', outputFile);
end
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, '%s\n', json);
fprintf('Wrote Simulink inventory: %s\n', outputFile);
end

function blocks = collectBlocks(blockPaths)
blocks = repmat(struct( ...
    'path', '', ...
    'name', '', ...
    'blockType', '', ...
    'maskType', '', ...
    'referenceBlock', '', ...
    'dialogParameters', {{}}, ...
    'objectParameters', {{}}), 0, 1);

for i = 1:numel(blockPaths)
    path = blockPaths{i};
    item = struct();
    item.path = path;
    item.name = safeGetParam(path, 'Name');
    item.blockType = safeGetParam(path, 'BlockType');
    item.maskType = safeGetParam(path, 'MaskType');
    item.referenceBlock = safeGetParam(path, 'ReferenceBlock');
    item.dialogParameters = parameterNames(path, 'DialogParameters');
    item.objectParameters = parameterNames(path, 'ObjectParameters');
    blocks(end + 1) = item; %#ok<AGROW>
end
end

function value = safeGetParam(path, paramName)
try
    value = get_param(path, paramName);
    if isempty(value)
        value = '';
    end
catch
    value = '';
end
end

function names = parameterNames(path, paramName)
try
    params = get_param(path, paramName);
    names = fieldnames(params);
catch
    names = {};
end
end
