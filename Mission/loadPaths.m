fprintf(1,'Loading Paths...');

global pathData
pathData.pathroot = fileparts(mfilename('fullpath'));
pathData.segments = [pathData.pathroot '\Segments'];
pathData.planform = [pathData.pathroot '\Planform'];
pathData.collections = [pathData.pathroot '\Planform\collections'];
pathData.engine = [pathData.pathroot '\Planform\engine'];
pathData.geometry = [pathData.pathroot '\Planform\geometry'];
pathData.global = [pathData.pathroot '\Planform\global'];
pathData.performance = [pathData.pathroot '\Planform\performance'];
pathData.weight = [pathData.pathroot '\Planform\weight'];
pathData.evalScripts = [pathData.pathroot '\EvaluationScripts'];
pathData.other = [pathData.pathroot '\Other'];

fields = fieldnames(pathData);
for i = 1:numel(fields)
    addpath(pathData.(fields{i}));
end
clear fields
fprintf(1,'Done\n')