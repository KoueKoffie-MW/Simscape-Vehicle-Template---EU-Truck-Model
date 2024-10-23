function startup_sm_car
% Startup file for sm_car.slx Example
% Copyright 2019-2023 The MathWorks, Inc.
% Function adapted by Lorenzo Nicoletti to reduce the truck model

curr_proj = simulinkproject;

% Add folders with Simscape Multibody tire subsystem to path if MATLAB version R2021b or higher
addpath([curr_proj.RootFolder filesep 'Libraries' filesep 'Vehicle' filesep 'Tire' filesep 'MFMbody' filesep 'MFMbody']);

%% Load visualization and other parameters in workspace
Visual = sm_car_param_visual('default');
assignin('base','Visual',Visual);

%% Create .mat files with Vehicle structure presets
evalin('base','Vehicle_data_LKW')
evalin('base','TrailerLKW');
evalin('base','Init_TrailerLKW');

%% Load Initial Vehicle state database
evalin('base','Init_data_LKW')

%% Load Maneuver database
evalin('base','Maneuver_LKW')

%% Load Driver database
sm_car_gen_driver_database;

%% Load Camera Frame Database
CDatabase.Camera = sm_car_gen_camera_database;
assignin('base','CDatabase',CDatabase)

%% Load driving surface parameters
Scene = sm_car_import_scene_data;
assignin('base','Scene',Scene);

%% Load control parameters
Control = sm_car_import_control_param;
assignin('base','Control',Control);

%% Create custom components for drag calculation
custom_code = dir('**/custom_abs.ssc');
cd(custom_code.folder)
ssc_build
cd(fileparts(which('sm_car_Axle3.slx')))

%% Additionally required for the DSD subsystem:
setup_Scenario

%% Modify solver settings - patch from development
limitDerivativePerturbations()
daesscSetMultibody()

sm_car_Axle3

end
