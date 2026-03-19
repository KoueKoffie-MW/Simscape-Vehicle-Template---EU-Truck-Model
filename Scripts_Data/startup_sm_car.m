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
% Please note that the Simulink model also has some callbacks
modelname = 'sm_car_Axle3';
open_system(modelname);

%% 2) Load Vehicle and Trailer Parameters
% Call the consolidated DAF truck parameter scripts
paramVehicle_DAF;
paramTrailer_DAF;

assignin('base','Trailer',Trailer);
assignin('base', 'Vehicle', Vehicle);


%% 3) Set up a Maneuver, the Initial Position of the Vehicle and the Driver
% Set up the parameters for the WOT scenario
[Maneuver, Init, Init_Trailer, Driver] = sm_car_config_maneuver(modelname,'wot braking');

% Assign the function to the MATLAB Workspace
assignin('base','Maneuver',Maneuver);
assignin('base','Init',Init);
assignin('base','Init_Trailer',Init_Trailer);
assignin('base','Driver',Driver);

%% Set the road option: Default Plane with constant height
sm_car_config_road(modelname,'Plane Grid');

%% Load Camera Frame Database
CDatabase.Camera = sm_car_gen_camera_database;
assignin('base','Camera',CDatabase.Camera.Amandla)

% Set up the visuals
Visual = sm_car_param_visual('default');
assignin('base','Visual',Visual);

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
end
