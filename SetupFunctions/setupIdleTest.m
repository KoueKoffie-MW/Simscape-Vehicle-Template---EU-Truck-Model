%% Description: 
% This script shows how to set up an idel test. 
% The vehicle will start in the start position and no movement will be
% imposed by the driver. This condition can be used to test whether the
% axles are stable at the beginning of the simulation

%% Implementation
% If the model is not open, then open it
if ~bdIsLoaded('sm_car_Axle3'); open_system('sm_car_Axle3'); end

% This function will load all parameter unless they are already in the workspace
startup_sm_car;

% Configure the maneuver: Set initial position, maneuver characteristics, and driver 
[Maneuver, Init, Init_Trailer, Driver] = sm_car_config_maneuver('sm_car_Axle3','idle');

% Set up the road surface
sm_car_config_road('sm_car_Axle3','plane grid');

% Simulate the model
sim('sm_car_Axle3');

% Post-processing 
figure; sm_car_plotmaneuver(Maneuver,logsout_sm_car);
figure; sm_car_plotspeed;
