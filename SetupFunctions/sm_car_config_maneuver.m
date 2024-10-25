function [Maneuver, Init, Init_Trailer, Driver] = sm_car_config_maneuver(modelname,maneuver)
%% Description
% This function can be used to set up a Maneuver. New Maneuver can be
% implemented here. The function is an alternative to avoid using Excel
% Tables for generating the maneuvers. 

%% Input: 
% modelname: The name of the model to be updated. which is sm_car_Axle3.slx
% maneuver:  The maneuver you want to test. This code implements two options 'wot braking' or 'double lane change'

%% Output:
% Maneuver    : Contains the information of the maneuver that will be performed
% Init        : initial position of the truck
% Init_Trailer: Initial position and speed of the trailer
% Driver      : Control parameter for driver model (only used if we have a closed loop case)

%% Implementation

% Radius of the wheels of both truck and trailer (needed to estimate intial wheel speed)
radiusWheel = 0.6731; % in m

% Find variant subsystems for settings
f          = Simulink.FindOptions('regexp',1);
drive_h    = Simulink.findBlocks(modelname,'popup_driver_type','.*',f);

%% WOT Maneuver: These variables set up a WOT Maneuver for the vehicle
if strcmp(maneuver,'wot braking')
% 1) Set the maneuver characteristics
    % Brake pedal position (0-1) over time (in sec) 
    Maneuver.Brake.t.Value      = [0 16 16.2 190 191 200];
    Maneuver.Brake.rPedal.Value = [0 0  1    1   0   0];
    
    % Steering position angle (rad) over the time (sec)
    Maneuver.Steer.t.Value      = [0 200];
    Maneuver.Steer.aWheel.Value = [0 0];
    
    % Acceleration pedal position (0-1) over time (in sec) 
    Maneuver.Accel.t.Value      = [0 1 1.2 15 15.2 200];
    Maneuver.Accel.rPedal.Value = [0 0 1   1  0    0];
    
% 2) Select the initial position of the truck AND trailer
    Init.Chassis.aChassis.Value = [0,0,0]; % Start angle of the Vehicle COG in rad [Roll,Pitch,Yaw]
    Init.Chassis.vChassis.Value = [1,0,0]; % Start speed of the Vehicle COG in m/s [vx, vy, vz]
    Init.Chassis.sChassis.Value = [5,0,0]; % Start position of the vehicle COG in m [px, py, pz]
    Init_Trailer.Chassis = Init.Chassis; % Same values for the trailer

% 3) Set the Maneuver to be an Open Loop maneuver
    set_param(drive_h,'popup_driver_type','Open Loop');

% 4) Set simulation Stop time 
    set_param(modelname,'StopTime','40');

% 5) Set the road type (e.g. Plane grid)
    sm_car_config_road(modelname,'Plane Grid');
end

%% Double Lane Change Maneuver: These variables set up a DLC Maneuver for the vehicle
if strcmp(maneuver,'double lane change')

%1) Set variable needed for the path following algorithm
    Maneuver.xMaxLat.Value    = 5; % Max lateral distance in m
    Maneuver.vMinTarget.Value = 5; % Minimum target speed in m/s
    Maneuver.vGain.Value      = 1; % Scaler for speed trajectory vx

    % Preview distance in m for different speed (in m/s)
    Maneuver.xPreview.x.Value = [2.5 3 21];
    Maneuver.xPreview.v.Value = [0 5 20];

    % The actual trajectory. Has the following variables
    % x,y,z coordinates in m | vx: Speed over time in m/s
    % aYaw Yaw angle in rad  | Trajectory.xTrajectory: Driven speed in m
    Trajectory = load('Double_Lane_Change_trajectory_default');
    Maneuver.Trajectory = Trajectory;

% 2) Select the initial position of the truck:
    Init.Chassis.aChassis.Value = [0,0,0]; % Start angle of the Vehicle COG in rad [Roll,Pitch,Yaw]
    Init.Chassis.vChassis.Value = [2.5,0,0]; % Start speed of the Vehicle COG in m/s [vx, vy, vz]
    Init.Chassis.sChassis.Value = [5 -5.8500 0]; % Start position of the vehicle COG in m [px, py, pz]
    Init_Trailer.Chassis        = Init.Chassis; % Same values for the trailer
    
% 3) Set the Maneuver to be an Closed Loop maneuver
    set_param(drive_h,'popup_driver_type','Closed Loop');

% 4) Set simulation Stop time 
    set_param(modelname,'StopTime','40');

% 5) Set the road type to be used
    sm_car_config_road(modelname,'Double Lane Change');
end

% Inform the user if what he chose is not availbale:
if ~exist('Maneuver','var')
    disp('Error the maneuver you selected is not available');
    return
end

% From the initial conditions, set up also the speed of the wheels
Init = sm_car_config_tire_speed(Init, radiusWheel,3);
Init_Trailer = sm_car_config_tire_speed(Init_Trailer, radiusWheel,2);

% For maneuver with a Closed Loop Model, a driver will be needed:
Driver = sm_car_config_driver();

end


function Init = sm_car_config_tire_speed(Init, radiusWheel, numAxes)
%% Description: 
% This function calculates the required initial speed for the wheels given
% a certain transnational speed for the vehicle. In this way at the start of
% the simulation the wheel speed is compatible with the vehicle speed and
% the simulation initializes faster

speedChassis = Init.Chassis.vChassis.Value(1);

Init.Axle1.nWheel.Value = [speedChassis/radiusWheel, speedChassis/radiusWheel, radiusWheel];
Init.Axle2.nWheel.Value = [speedChassis/radiusWheel, speedChassis/radiusWheel, radiusWheel];

if numAxes ==3
   Init.Axle3.nWheel.Value = [speedChassis/radiusWheel, speedChassis/radiusWheel, radiusWheel];
end

end