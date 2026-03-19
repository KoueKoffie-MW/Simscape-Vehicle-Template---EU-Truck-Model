function Driver = sm_car_config_driver()

%% Description: 
% This model sets up the parameter used for the driver model. 
% Consolidated to be the single source of truth for the DAF Truck.

%% 1) Data used for the longitudinal driver
Driver.Long.mVehicle.Value = 2550;           % Vehicle mass reference in kg';
Driver.Long.FTractive.Value = 17297;         % Maximum tractive force in N
Driver.Long.tDriver.Value = 0.1;             % Reaction time driver in sec
Driver.Long.xPreview.Value = 20;             % Preview distance driver in m
Driver.Long.NDragRoll.Value = 200;           % Rolling resistance coefficient in N
Driver.Long.NDragRollDriveline.Value = 2.5;  % Rolling and driveline resistance coefficient in N*s/m
Driver.Long.NDragAero.Value = 0;             % Aerodynamic drag coefficient, cR in N*s^2/m^2
Driver.Long.gGravity.Value = 9.80665;        % Gravitational constant in m/s2
Driver.Long.fAccelCutoff.Value = 31.4159265; % Acceleration Cutoff frequency in Hz
Driver.Long.fBrakeCutoff.Value = 31.4159265; % Brake cutoff frequency in Hz

% Missing fields previously only in paramDriver.m
Driver.Long.FFLookahead.Value = 0.5;
Driver.Long.NRollingResistance.Value = 0.01;
Driver.Long.NRoadFriction.Value = 0.9;
Driver.Long.Kp.Value = 0.3125;
Driver.Long.Ki.Value = 0.0391;
Driver.Long.gMaxAccel.Value = 5;
Driver.Long.gMaxDecel.Value = -10;

%% 2) Data used for the lateral driver
Driver.Lateral.Stanley.NForward.Value = 1;
Driver.Lateral.Stanley.NReverse.Value = 0.25; 

% Centralized Wheelbase (try to get from workspace first)
try
    Driver.Lateral.xWheelbase.Value = evalin('base', 'Vehicle.Chassis.Body.xWheelbase.Value');
catch
    Driver.Lateral.xWheelbase.Value = 4.735;    % DAF Truck default
end

Driver.Lateral.aMaxSteer.Value = 35;            % Maximum steering angle in deg
Driver.Lateral.fSteerCutoff.Value = 314.159265; % Steering command cutoff speed
Driver.Lateral.class.Value = 'Stanley';

end