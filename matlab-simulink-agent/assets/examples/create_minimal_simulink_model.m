function create_minimal_simulink_model(outdir)
%CREATE_MINIMAL_SIMULINK_MODEL Build, run, and export a minimal Simulink model.

if nargin < 1 || strlength(string(outdir)) == 0
    outdir = fullfile(pwd, 'generated-minimal-model');
end
outdir = char(string(outdir));

if ~exist(outdir, 'dir')
    mkdir(outdir);
end

model = 'minimal_gain_model';

if bdIsLoaded(model)
    close_system(model, 0);
end

new_system(model);
load_system('simulink');

add_block('simulink/Sources/Step', [model '/Step'], ...
    'Position', [80 100 120 130], ...
    'Time', '1', ...
    'Before', '0', ...
    'After', '1');

add_block('simulink/Math Operations/Gain', [model '/Gain'], ...
    'Position', [190 95 250 135], ...
    'Gain', '2');

add_block('simulink/Sinks/To Workspace', [model '/To Workspace'], ...
    'Position', [330 95 430 135], ...
    'VariableName', 'y', ...
    'SaveFormat', 'StructureWithTime');

add_line(model, 'Step/1', 'Gain/1', 'autorouting', 'on');
add_line(model, 'Gain/1', 'To Workspace/1', 'autorouting', 'on');

set_param(model, ...
    'StopTime', '5', ...
    'Solver', 'ode45', ...
    'ReturnWorkspaceOutputs', 'on');

modelPath = fullfile(outdir, [model '.slx']);
save_system(model, modelPath);

simOut = sim(model, 'ReturnWorkspaceOutputs', 'on');
y = simOut.get('y');

T = table(y.time, y.signals.values, 'VariableNames', {'time', 'value'});
writetable(T, fullfile(outdir, [model '_output.csv']));

fig = figure('Visible', 'off');
plot(T.time, T.value, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Output');
grid on;
saveas(fig, fullfile(outdir, [model '_output.png']));
close(fig);

save(fullfile(outdir, [model '_simout.mat']), 'simOut');
close_system(model, 0);

fprintf('Generated model: %s\n', modelPath);
fprintf('Generated output: %s\n', fullfile(outdir, [model '_output.csv']));
end
