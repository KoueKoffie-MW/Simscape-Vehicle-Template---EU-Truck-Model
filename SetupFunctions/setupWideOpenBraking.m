%% Description: 
% This script shows how to set up a wide open braking test and how to then
% simulate it. The wide open throttle test is set as an Open Loop
% Simulation meaning that the driver controller is not used. The user can
% choose whether to simulate with a flat surface or with a surface with
% variable altitude loaded using a CRG file

%% Inputs: 
roadSurface = 'plane'; % Choose 'plane' or 'CRG'

% If the model is not open, then open it
if ~bdIsLoaded('sm_car_Axle3'); open_system('sm_car_Axle3'); end

% This function will load all parameter unless they are already in the workspace
if ~exist('Camera','var'); startup_sm_car; end

% Configure the maneuver: Set initial position, maneuver characteristics, and driver 
[Maneuver, Init, Init_Trailer, Driver] = sm_car_config_maneuver('sm_car_Axle3','wot braking');

% Set up the road surface
switch roadSurface
    case 'plane'
        sm_car_config_road('sm_car_Axle3','plane grid');
    case 'CRG'
        sm_car_config_road('sm_car_Axle3','crg rough road');
end

% For this configuration the Driving Scenario is not activated
set_param(['sm_car_Axle3/Scenario Interpreter'], 'LabelModeActiveChoice','None');

% Simulate the model
sim('sm_car_Axle3');

% Post-processing 
sm_car_plotmaneuver(Maneuver,logsout_sm_car);
% sm_car_plotspeed