function sm_car_vehicle_data = sm_car_import_vehicle_data(updateData,showMessage)
%% Description:
% This function has been modified to enable an import from the full list of
% Excel tables

% Copyright 2019-2023 The MathWorks, Inc.

sm_car_vehicle_data = [];
VDatabase = [];

% Find Excel files with vehicle data (based on filename)
curr_dir = pwd;
cd(fileparts(which('FINDME.m')));
car_data_excel_list = dir('**/*.xlsx');

[~, alpha_ind] = sort({car_data_excel_list.name});

% Loop over Excel files
for excel_i = 1:length(car_data_excel_list)
    
    % Get data from file
    tempDatabase = sm_car_import_database(car_data_excel_list(alpha_ind(excel_i)).name,{'Structure','NameConvention'},showMessage);
    
    % Get list of types from file
    typename = fieldnames(tempDatabase);
    
    % Loop over list of types
    for type_i = 1:length(typename)
        
        % If VDatabase is empty, set flag
        if(isempty(sm_car_vehicle_data))
            VDatabase_names = 'none';
        else
            VDatabase_names = fieldnames(sm_car_vehicle_data);
            % If VDatabase has no fields, set flag
            if(isempty(VDatabase_names))
                VDatabase_names = 'none';
            end
        end
        
        % If type exists in VDatabase, add instances to VDatabase
        if(find(strcmp(VDatabase_names,typename{type_i})))
            
            % Loop over instances
            instance_names = fieldnames(tempDatabase.(typename{type_i}));
            for inst_i = 1:length(instance_names)
                sm_car_vehicle_data.(typename{type_i}).(instance_names{inst_i}) = tempDatabase.(typename{type_i}).(instance_names{inst_i});
            end
            
            
        else
            % Else, add entire type to VDatabase
            sm_car_vehicle_data.(typename{type_i}) = tempDatabase.(typename{type_i});
        end
    end
    filedata = dir(which(car_data_excel_list(alpha_ind(excel_i)).name));
    sm_car_vehicle_data.files(excel_i+1).filename = filedata.name;
    sm_car_vehicle_data.files(excel_i+1).date = filedata.datenum;
end

sm_car_vehicle_data_orig = sm_car_vehicle_data;
sm_car_vehicle_data = [];

typenames_list = fieldnames(sm_car_vehicle_data_orig);
sorted_typenames_list = sort(typenames_list);
for tn_i = 1:length(sorted_typenames_list)
    sm_car_vehicle_data.(sorted_typenames_list{tn_i}) = sm_car_vehicle_data_orig.(sorted_typenames_list{tn_i});
end

VDatabase = sm_car_vehicle_data;
save VDatabase_file VDatabase

cd(curr_dir)