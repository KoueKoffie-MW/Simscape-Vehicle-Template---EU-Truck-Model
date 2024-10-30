function Vehicle = sm_car_param_cabin(Vehicle)
%% Description: 
% This script loads the parameters required by the model
% truckCabinModel.slx 
 
%% CABIN VALUES:
% Initial position of the COG:
cabin.originStart = [0.4969,  0, 1.5704];
cabin.m = 1242.63; % Mass of the cabin in kg
cabin.J = [1490.0 , 1273.0, 1476.4];  % Inertia in the cabin fixed frame in kgm^2 as [Jxx, Jyy, Jzz]    

%% SHOCK ABSORBERS
% Load look up tables for damper and spring: 
[cabin.damperFront,cabin.springFront,cabin.damperRear,cabin.springRear] = loadLUTs();

% FRONT AXLE: Attach points shock absorber 
cabin.schockBotPosFL = [ 1.3250,  0.6550,  0.2190];
cabin.schockTopPosFL = [ 1.3250,  0.6550,  0.5540];
cabin.schockBotPosFR = [ 1.3250, -0.6550,  0.2190];
cabin.schockTopPosFR = [ 1.3250, -0.6550,  0.5540];

% REAR AXLE: Attach points shock absorber 
cabin.schockBotPosRL = [-0.4750,  0.5250,  0.2045];
cabin.schockTopPosRL = [-0.4750,  0.6000,  0.4950];
cabin.schockBotPosRR = [-0.4750, -0.5250,  0.2045];
cabin.schockTopPosRR = [-0.4750, -0.6000,  0.4950];

% Geometrical dimensions: 
cabin.shockPistonMass  = 3.6;
cabin.shockCylmass     = 2.0;
cabin.limitBumpUp      = 0.05;
cabin.limitBumpDown    = -0.05;
cabin.bumpLength       = 0.01;
cabin.cylCapLength     = 0.005;
cabin.shockPistonLength= 0.01;
cabin.deadVolLength    = 0.005;

%% SWING ARMS
% FRONT AXLE: Attach points for cabin and chassis side 
cabin.swingArmChasFL = [1.0350,  0.5050,  0.5960 ];
cabin.swingArmCabFL  = [1.3850,  0.5764,  0.6100 ];
cabin.swingArmChasFR = [1.0350, -0.5050,  0.5960 ];
cabin.swingArmCabFR  = [1.3850, -0.5764,  0.6100 ];

% Calculate the difference
RefDist           = cabin.swingArmCabFL -  cabin.swingArmChasFL;
cabin.azimuthFL   = atand(RefDist(2)/RefDist(1));
cabin.elevationFL = atand(RefDist(3)/(RefDist(1)^2+RefDist(2)^2)^0.5);

RefDist     = cabin.swingArmCabFR -  cabin.swingArmChasFR;
cabin.azimuthFR   = atand(RefDist(2)/RefDist(1));
cabin.elevationFR = atand(RefDist(3)/(RefDist(1)^2+RefDist(2)^2)^0.5);

% REAR AXLE: Attach points for cabin and chassis side 
cabin.swingArmChasRL = [-0.4750,  0.3500,  0.5600 ];
cabin.swingArmCabRL  = [-0.4750,  0.6000,  0.5750 ];
cabin.swingArmChasRR = [-0.4750, -0.3500,  0.5600 ];
cabin.swingArmCabRR  = [-0.4750, -0.6000,  0.5750 ];

%% ANTI ROLL BAR
% Inner and outer radius of the anti roll bar in m
cabin.antiRollBarRadiusInn = 0.5*45*1e-3;
cabin.antiRollBarRadiusOut = 0.5*55*1e-3;

% Material properties of the anti roll bar
cabin.antiRollBarEModulus  = 200;  % in GPa
cabin.antiRollBarDensity   = 7850; % in kg/m^3
cabin.antiRollBarPoisson   = 0.3;  % adimensional

%% GRAPHICAL PROPERTIES (for arrows, colors, and so on):
% Cabin color and opacity
cabin.cabinOpacity = 0.1;
cabin.cabinColor   = [83 213 255]/255;

% Arrows representing the forces
cabin.arrowHeight   = 0.05;
cabin.arrowNormFact = 8000; % Norming factor for the forces. E.g. ForcePlot = ForceReal/arrowNormFact

% Arrow representing the driving direction
cabin.arrow = [-1,-0.5;1,-0.5;1,-1;2,0;1,1;1,0.5;-1,0.5]*0.2;

% Assign back to the vehicle structure
Vehicle.Chassis.Body.Cabin = cabin;
end