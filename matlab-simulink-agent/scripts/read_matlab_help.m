function read_matlab_help(topic, outputFile)
%READ_MATLAB_HELP Export concise MATLAB help text for one topic.
%   read_matlab_help("sim", "sim-help.txt")

if nargin < 1 || strlength(string(topic)) == 0
    error('read_matlab_help:MissingTopic', 'A MATLAB help topic is required.');
end

if nargin < 2 || strlength(string(outputFile)) == 0
    validTopic = matlab.lang.makeValidName(char(string(topic)));
    outputFile = sprintf('%s-help.txt', validTopic);
end

topic = char(string(topic));
outputFile = char(string(outputFile));

helpText = help(topic);
location = which(topic);

fid = fopen(outputFile, 'w');
if fid < 0
    error('read_matlab_help:OpenFailed', 'Could not open output file: %s', outputFile);
end
cleanup = onCleanup(@() fclose(fid));

fprintf(fid, 'TOPIC: %s\n', topic);
fprintf(fid, 'WHICH: %s\n\n', location);
fprintf(fid, '%s\n', helpText);
end
