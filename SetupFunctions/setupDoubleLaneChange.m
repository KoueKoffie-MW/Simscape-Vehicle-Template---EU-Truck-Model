%% Description: 
% This script shows how to set up a wide open throttle test and how to then
% simulate it. The wide open throttle test is set as an Open Loop
% Simulation meaning that the driver controller is not used. The user can
% choose whether to simulate with a flat surface or with a surface with
% variable altitude loaded using a CRG file

%% Inputs: 
% If the model is not open, then open it
if ~bdIsLoaded('sm_car_Axle3'); open_system('sm_car_Axle3'); end

% This function will load all parameter unless they are already in the workspace
if ~exist('Camera','var'); startup_sm_car; end

% Configure the maneuver: Set initial position, maneuver characteristics, and driver 
[Maneuver, Init, Init_Trailer, Driver] = sm_car_config_maneuver('sm_car_Axle3','double lane change');

% Open the function below to modify any of the cabin suspension parameters:
Vehicle = sm_car_param_cabin(Vehicle);

% Set the road type to be used
sm_car_config_road('sm_car_Axle3','double lane change');

% For this configuration the Driving Scenario is not activated
set_param([bdroot,'/Scenario Interpreter'], 'LabelModeActiveChoice','None');

% Simulate the model
sim(bdroot);

% Post-processing 
sm_car_plotmaneuver(Maneuver,logsout_sm_car);
sm_car_plotspeed