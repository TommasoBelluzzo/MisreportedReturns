warning('off','all');

close('all');
clearvars();
clc();

[path,~,~] = fileparts(mfilename('fullpath'));

if (~strcmpi(path(end),filesep()))
    path_base = [path filesep()];
end

if (~isempty(regexpi(path_base,'Editor')))
    path_base_fs = dir(path_base);
    is_live = ~all(cellfun(@isempty,regexpi({path_base_fs.name},'LiveEditorEvaluationHelper')));

    if (is_live)
        while (true)
            ia = inputdlg('It looks like the program is being executed as a live script. Please, manually enter the root folder of this package:','Manual Input Required');
    
            if (isempty(ia))
                return;
            end
            
            path_base_new = ia{:};

            if (isempty(path_base_new) || strcmp(path_base_new,path_base) || strcmp(path_base_new(1:end-1),path_base) || ~exist(path_base_new,'dir'))
               continue;
            end
            
            path_base = path_base_new;
            
            break;
        end
    end
end

if (~strcmpi(path_base(end),filesep()))
    path_base = [path_base filesep()];
end

paths_base = genpath(path_base);
paths_base = strsplit(paths_base,';');

for i = numel(paths_base):-1:1
    path_cur = paths_base{i};

    if (~strcmp(path_cur,path_base) && isempty(regexpi(path_cur,[filesep() 'Scripts'])))
        paths_base(i) = [];
    end
end

paths_base = [strjoin(paths_base,';') ';'];
addpath(paths_base);

data = parse_dataset(fullfile(path,'\Datasets\Example.xlsx'));
td = execute_tests(data,false);

plot_data(data,true);
plot_results(td);

rmpath(paths_base);
