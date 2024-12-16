%% Description
% This script is the central storage for all the modification required in
% order to simulate the DAF truck. The script stores all the changes
% performed to the default truck (USA truck) in order to adapt it to a EU
% truck

%% 1) Tire Models: The tires were changed to a smaller variant:
% Select newly created tire component for the truck
Vehicle.Chassis.TireA1.TireBody.class.Value           = 'CAD_DAF_Truck';
Vehicle.Chassis.TireA2.TireOuter.TireBody.class.Value = 'CAD_DAF_Truck_2x';
Vehicle.Chassis.TireA3.TireOuter.TireBody.class.Value = 'CAD_DAF_Truck_2x';
Trailer.Chassis.TireA2.TireOuter.TireBody.class.Value = 'CAD_DAF_Truck_2x';
Trailer.Chassis.TireA1.TireOuter.TireBody.class.Value = 'CAD_DAF_Truck_2x';

% The position of the wheel center have to be modified (smaller radius and track width) 
Vehicle.Chassis.SuspA1.Simple.sWheelCentre.Value = [0,1012/1000, 1055/2000];
Vehicle.Chassis.SuspA2.Simple.sWheelCentre.Value = [0, 881/1000, 1055/2000];
Vehicle.Chassis.SuspA3.Simple.sWheelCentre.Value = [0, 881/1000, 1055/2000];
Trailer.Chassis.SuspA1.Simple.sWheelCentre.Value = [0, 881/1000, 1055/2000];
Trailer.Chassis.SuspA2.Simple.sWheelCentre.Value = [0, 881/1000, 1055/2000];

% Update the correct tire radius also on the Tire struct
Vehicle.Chassis.TireA3.tire_radius.Value = 1055/2000;
Vehicle.Chassis.TireA2.tire_radius.Value = 1055/2000;
Vehicle.Chassis.TireA1.tire_radius.Value = 1055/2000;

% Provide the name of the new tir file created for the DAF truck
Vehicle.Chassis.TireA1.tirFile.Value           = 'which(''Truck_214_10R39.tir'')';
Vehicle.Chassis.TireA2.TireOuter.tirFile.Value = 'which(''Truck_214_10R39.tir'')';
Vehicle.Chassis.TireA2.TireInner.tirFile.Value = 'which(''Truck_214_10R39.tir'')';
Vehicle.Chassis.TireA3.TireOuter.tirFile.Value = 'which(''Truck_214_10R39.tir'')';
Vehicle.Chassis.TireA3.TireInner.tirFile.Value = 'which(''Truck_214_10R39.tir'')';
Trailer.Chassis.TireA1.TireInner.tirFile.Value = 'which(''Truck_214_10R39.tir'')';
Trailer.Chassis.TireA1.TireOuter.tirFile.Value = 'which(''Truck_214_10R39.tir'')';
Trailer.Chassis.TireA2.TireInner.tirFile.Value = 'which(''Truck_214_10R39.tir'')';
Trailer.Chassis.TireA2.TireOuter.tirFile.Value = 'which(''Truck_214_10R39.tir'')';

%% Trailer Position:
% Adjust Hitch Rear Position so that the trailer is located at the right height
Vehicle.Chassis.Body.sHitchR.Value = [-1.25,0, 1.4778];

%% Driver and Steering Wheel Position
% Position the driver and the steering wheel:
Vehicle.Chassis.SuspA1.Steer.DriverHuman.s.Value = [0.2300    0.6080    1.7400];
Vehicle.Chassis.SuspA1.Steer.Wheel.sMount.Value  = [0.5800    0.6080    1.9400];

%% Cabin and Chassis 
% Cabin mass and inertia:
Vehicle.Chassis.Body.Cabin.m.Value = 1200;               % in kg
Vehicle.Chassis.Body.Cabin.J.Value = [1300, 1200, 1300]; % in kgm^2

% Position the Chassis COG height with respect to the ground
Vehicle.Chassis.Body.sCG.Value(3) = 0.720;

% Added variable to position the COG of the cabin
Vehicle.Chassis.Cabin.sCG.Value = [0,0,1.2];

%% Axles positions of the truck
% Measured in CAD
Vehicle.Chassis.Body.sAxle2.Value = [-3.365,0,0];
Vehicle.Chassis.Body.sAxle3.Value = [-4.735,0,0];
% Vehicle.Chassis.SuspA1.Steer.DriverHuman.class.Value = 'None';

% Position the steering wheel with respect to the Front Axle
% Vehicle.Chassis.SuspA1.Steer.Wheel.sMount.Value = [0.7,0.558,2];

% Initial positions
Init.Chassis.sChassis.Value         = [15,0,0];
Init_Trailer.Chassis.sChassis.Value = [15,0,0];

%% Graphical Properties:
% Colors for the truck (different structure because we have more part)
Vehicle.Chassis.Body.BodyGeometry.cabinColor.Value      = [1.0 1.0 0.4];
Vehicle.Chassis.Body.BodyGeometry.cabinCoverColor.Value = [0 0 0];
Vehicle.Chassis.Body.BodyGeometry.chassisColor.Value    = [0.8 0.8 0.8];
Vehicle.Chassis.Body.BodyGeometry.wheelCoverColor.Value = [1,0,0];
Trailer.Chassis.Body.BodyGeometry.wheelCoverColor.Value = [1,0,0];
Trailer.Chassis.Body.BodyGeometry.trailerColor.Value    = [1.0 1.0 0.4];
Trailer.Chassis.Body.BodyGeometry.chassisColor.Value    = [0.8 0.8 0.8];

%% Suspension PRe-Load and Stiffness
% Set the stiffness of the 5 axes in N/m
Vehicle.Chassis.SuspA1.Simple.Heave.K.Value = 70000; 
Vehicle.Chassis.SuspA3.Simple.Heave.K.Value = 6.6667e+04;
Vehicle.Chassis.SuspA2.Simple.Heave.K.Value = 6.6667e+04;
Trailer.Chassis.SuspA1.Simple.Heave.K.Value = 6.6667e+04;
Trailer.Chassis.SuspA2.Simple.Heave.K.Value = 6.6667e+04;

% Set the preload of the axes in m
Vehicle.Chassis.SuspA1.Simple.Heave.xInit.Value = -0.3556;    
Vehicle.Chassis.SuspA2.Simple.Heave.xInit.Value = -0.0889;  
Vehicle.Chassis.SuspA3.Simple.Heave.xInit.Value = -0.0889;    
Trailer.Chassis.SuspA1.Simple.Heave.xInit.Value = -0.0889;
Trailer.Chassis.SuspA2.Simple.Heave.xInit.Value = -0.0889;