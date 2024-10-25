function Driver = sm_car_config_driver()

%% Description: 
% This model sets up the parameter used for the driver model. The driver
% model is needed for closed loop simulation and is composed by a
% longitudinal driver (used to regulate acceleration and brake command) as
% well as a lateral driver (used to regulate steering command)

%% 1) Data used for the longitudinal driver
Driver.Long.mVehicle.Value = 2550;           % Vehicle mass used by the driver as reference in kg';
Driver.Long.FTractive.Value = 17297;         % Maximum tractive force in N
Driver.Long.tDriver.Value = 0.1;             % Reaction time driver in sec
Driver.Long.xPreview.Value = 20;             % Preview distance driver in m
Driver.Long.NDragRoll.Value = 200;           % Rolling resistance coefficient in N
Driver.Long.NDragRollDriveline.Value = 2.5;  % Rolling and driveline resistance coefficient in N*s/m
Driver.Long.NDragAero.Value = 0;             % Aerodynamic drag coefficient, cR in N*s^2/m^2
Driver.Long.gGravity.Value = 9.80665;        % Gravitational constant in m/s2
Driver.Long.fAccelCutoff.Value = 31.4159265; % Acceleration Cutoff frequency in Hz
Driver.Long.fBrakeCutoff.Value = 31.4159265; % Brake cutoff frequency in Hz

%% 2) Data used for the lateral driver
Driver.Lateral.NForward.Value = 1;              % Position gain of forward motion
Driver.Lateral.NReverse.Value = 2.5;            % Position gain of reverse motion
Driver.Lateral.xWheelbase.Value = 6.482;        % Wheelbase of vehicle in m
Driver.Lateral.aMaxSteer.Value = 55;            % Maximum steering angle in deg
Driver.Lateral.fSteerCutoff.Value = 314.159265; % Steering command cutoff speed


end