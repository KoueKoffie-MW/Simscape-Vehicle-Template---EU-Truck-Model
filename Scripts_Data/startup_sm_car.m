function startup_sm_car
%% Description:
% This function is called when starting up the model and initializes it
% with a wide open throttle scenario and a flat driving surface

%% Following outputs will be placed in the MATLAB Workspace:
% Maneuver    : Contains the information of the maneuver that will be performed
% Init        : initial position of the truck
% Init_Trailer: Initial position and speed of the trailer
% Driver      : Control parameter for driver model (only used if we have a closed loop case)
% Vehicle     : Contains vehicle parameters
% Trailer     : Contains trailer parameters
% Control     : Parameters for the controllers (except the driver)
% Scene       : Parameters for the scene (e.g. road shape, cone position, etc.)

%% 1) Open the model
% Please note that the simulink model also has some callbacks
sm_car_Axle3

%% Load the Vehicle and Truck Parameters
% Parameters for the Vehicle
load('Vehicle.mat');
assignin('base','Vehicle',Vehicle);

% Parameters for the trailer
load('Trailer.mat');
assignin('base','Trailer',Trailer);

%% Initial Positions:
[Maneuver, Init, Init_Trailer, Driver] = sm_car_config_maneuver(bdroot,'wot braking');

% Assign the function to the MATLAB Workspace
assignin('base','Maneuver',Maneuver);
assignin('base','Init',Init);
assignin('base','Init_Trailer',Init_Trailer);
assignin('base','Driver',Driver);

%% Set the road option: Default Plane with constant height
sm_car_config_road(modelname,'Plane Grid');

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

%% Additionally required for the Scenario Interpreter
setup_Scenario

%% Modify solver settings - patch from development
% limitDerivativePerturbations()
% daesscSetMultibody()
end
