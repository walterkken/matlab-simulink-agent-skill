function matlab_doc_lookup(query, outputFile)
%MATLAB_DOC_LOOKUP Write task-local documentation clues for a MATLAB query.
%   matlab_doc_lookup("sim", "doc-sim.txt")
%   matlab_doc_lookup("programmatic model editing", "doc-model-editing.txt")

if nargin < 1 || strlength(string(query)) == 0
    error('matlab_doc_lookup:MissingQuery', 'A query or topic is required.');
end

query = char(string(query));

if nargin < 2 || strlength(string(outputFile)) == 0
    outputFile = sprintf('%s-doc-lookup.txt', matlab.lang.makeValidName(query));
end
outputFile = char(string(outputFile));

fid = fopen(outputFile, 'w');
if fid < 0
    error('matlab_doc_lookup:OpenFailed', 'Could not open output file: %s', outputFile);
end
cleanup = onCleanup(@() fclose(fid));

fprintf(fid, 'QUERY: %s\n', query);
fprintf(fid, 'MATLAB_VERSION: %s\n', version);
fprintf(fid, 'MATLABROOT: %s\n\n', matlabroot);

writeSection(fid, 'WHICH', safeWhich(query));
writeSection(fid, 'HELP', safeHelp(query));
writeSection(fid, 'LOOKFOR', safeLookfor(query));
writeSection(fid, 'HELP_INDEX_MATCHES', helpIndexMatches(query, 80));
end

function text = safeWhich(topic)
try
    text = which(topic, '-all');
    if iscell(text)
        text = strjoin(text, newline);
    end
    if isempty(text)
        text = '(no which result)';
    end
catch ME
    text = sprintf('which failed: %s', ME.message);
end
end

function text = safeHelp(topic)
try
    text = help(topic);
    if isempty(text)
        text = '(no help text)';
    end
catch ME
    text = sprintf('help failed: %s', ME.message);
end
end

function text = safeLookfor(query)
try
    text = evalc('lookfor(query)');
    if isempty(strtrim(text))
        text = '(no lookfor result)';
    end
catch ME
    text = sprintf('lookfor failed: %s', ME.message);
end
end

function text = helpIndexMatches(query, maxMatches)
queryLower = lower(query);
files = dir(fullfile(matlabroot, 'help', '**', 'helpfuncbycat.xml'));
matches = strings(0, 1);

for k = 1:numel(files)
    filePath = fullfile(files(k).folder, files(k).name);
    try
        raw = fileread(filePath);
    catch
        continue
    end

    lines = regexp(raw, '\r\n|\n|\r', 'split');
    for i = 1:numel(lines)
        line = strtrim(lines{i});
        if contains(lower(line), queryLower)
            matches(end + 1, 1) = sprintf('%s: %s', filePath, line); %#ok<AGROW>
            if numel(matches) >= maxMatches
                text = strjoin(matches, newline);
                return
            end
        end
    end
end

if isempty(matches)
    text = '(no installed help index matches)';
else
    text = strjoin(matches, newline);
end
end

function writeSection(fid, title, body)
fprintf(fid, '## %s\n', title);
fprintf(fid, '%s\n\n', body);
end
