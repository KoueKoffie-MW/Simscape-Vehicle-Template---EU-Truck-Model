% TODO: 
% 1) It seems that the wheel track is still slightly to big, so that the wheel collide with their cover
% 2) The suspensions are not stable at the start, need to retune them
% 3) The coordinate frames of the A2 and A1 of the trailer is below the ground for some reason



% Select correct tire body model
Vehicle.Chassis.TireA1.TireBody.class.Value           = 'CAD_DAF_Truck';
Vehicle.Chassis.TireA2.TireOuter.TireBody.class.Value = 'CAD_DAF_Truck_2x';
Vehicle.Chassis.TireA3.TireOuter.TireBody.class.Value = 'CAD_DAF_Truck_2x';
Trailer.Chassis.TireA2.TireOuter.TireBody.class.Value = 'CAD_DAF_Truck_2x';
Trailer.Chassis.TireA1.TireOuter.TireBody.class.Value = 'CAD_DAF_Truck_2x';

% Correct the position of the wheel center for the suspensions
Vehicle.Chassis.SuspA1.Simple.sWheelCentre.Value(3) = 1055/2000;
Vehicle.Chassis.SuspA2.Simple.sWheelCentre.Value(3) = 1055/2000;
Vehicle.Chassis.SuspA3.Simple.sWheelCentre.Value(3) = 1055/2000;
Trailer.Chassis.SuspA1.Simple.sWheelCentre.Value(3) = 1055/2000;
Trailer.Chassis.SuspA2.Simple.sWheelCentre.Value(3) = 1055/2000;

% Apply correct radius to the tires
Vehicle.Chassis.TireA3.tire_radius.Value = 1055/2000;
Vehicle.Chassis.TireA2.tire_radius.Value = 1055/2000;
Vehicle.Chassis.TireA1.tire_radius.Value = 1055/2000;

Vehicle.Chassis.TireA1.tirFile.Value           = 'which(''Truck_214_10R39.tir'')';
Vehicle.Chassis.TireA2.TireOuter.tirFile.Value = 'which(''Truck_214_10R39.tir'')';
Vehicle.Chassis.TireA2.TireInner.tirFile.Value = 'which(''Truck_214_10R39.tir'')';
Vehicle.Chassis.TireA3.TireOuter.tirFile.Value = 'which(''Truck_214_10R39.tir'')';
Vehicle.Chassis.TireA3.TireInner.tirFile.Value = 'which(''Truck_214_10R39.tir'')';
Trailer.Chassis.TireA1.TireInner.tirFile.Value = 'which(''Truck_214_10R39.tir'')';
Trailer.Chassis.TireA1.TireOuter.tirFile.Value = 'which(''Truck_214_10R39.tir'')';
Trailer.Chassis.TireA2.TireInner.tirFile.Value = 'which(''Truck_214_10R39.tir'')';
Trailer.Chassis.TireA2.TireOuter.tirFile.Value = 'which(''Truck_214_10R39.tir'')';


% Adjust Hitch Rear Position so that the trailer is located correctly
Vehicle.Chassis.Body.sHitchR.Value = [-2,0, 1.4778]; 

% Position the wheel with respect to the Front Axle
Vehicle.Chassis.SuspA1.Steer.Wheel.sMount.Value = [0.7,0.558,2];


% Position the Chassis COG height with respect to the ground
Vehicle.Chassis.Body.sCG.Value(3) = 0.720;

% Added variable to position the COG of the cabin
Vehicle.Chassis.Cabin.sCG.Value = [0,0,1.2];

% Measured in CAD
Vehicle.Chassis.Body.sAxle2.Value = [-3.365,0,0];
Vehicle.Chassis.Body.sAxle3.Value = [-4.735,0,0];

% Added to the structure to shift the trailer 
Trailer.Chassis.Body.BodyGeometry.sOffsetTrailerZ = -0.5;

[Maneuver, Init, Init_Trailer, Driver] = sm_car_config_maneuver('sm_car_Axle3','wot braking');

% Initial positions
Init.Chassis.sChassis.Value = [15,0,0];
Init_Trailer.Chassis.sChassis.Value = [15,0,0];
