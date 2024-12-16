%% Description: 
% This script tunes the suspension stiffness and pre-load so that the
% deformation of the suspensions at the start of the simulation is as small
% as possible. The aim is to tune the suspensions to perfectly balance the
% static load of the vehicle

% I assume the following optimization variables:
% c1, x1  : Stiffness (N/m) and pre-load (m) of the front axle
% c23, x23: Stiffness (N/m) and pre-load (m) of the second and third axle of the truck
% c45, x45: Stiffness (N/m) and pre-load (m) of the trailer axle

% All variable are considered as discrete and can assume 10 different values
lb      = [1,   1,  1,  1,  1,  1];  % The lower bound of [c1, c23, c45, x1, x23, x45]
ub      = [10, 10, 10, 10, 10, 10];  % The upper bound of [c1, c23, c45, x1, x23, x45]
intCond = [1,2,3,4,5,6];

% Set up the optimizer options:
options = optimoptions(@surrogateopt,'PlotFcn',@surrogateoptplot,'Display', 'testing', ...
                       'InitialPoints',[],'MinSurrogatePoints', 25, 'MaxFunctionEvaluation',45);

% Model in Fast Restart to save time during optimization
set_param(bdroot,'FastRestart','on');

% Optimize
[x,fval,exitflag,output,trials] = surrogateopt(@optimizeTruck,lb,ub,intCond,[],[],[],[],options);

% Store the resulting values of the optimization
c1 = interp1(1:10,linspace(5*1e4,8e4,10),x(1),'nearest');
c23 = interp1(1:10,linspace(5*1e4,8e4,10),x(2),'nearest');
c45 = interp1(1:10,linspace(5*1e4,8e4,10),x(3),'nearest');
x1 = interp1(1:10,linspace(-0.4,0,10),   x(4),'nearest');
x23 = interp1(1:10,linspace(-0.4,0,10),   x(5),'nearest');
x45 = interp1(1:10,linspace(-0.4,0,10),   x(6),'nearest');


%% Objective Function
function response = optimizeTruck(x)  
    % Get the trailer and Vehicle variables
    Trailer = evalin('base', 'Trailer');    
    Vehicle = evalin('base', 'Vehicle');

    %% Allocate the parameter proposed by the optimizer
    c1 = interp1(1:10,linspace(5*1e4,8e4,10),x(1),'nearest');
    c23 = interp1(1:10,linspace(5*1e4,8e4,10),x(2),'nearest');
    c45 = interp1(1:10,linspace(5*1e4,8e4,10),x(3),'nearest');
    x1 = interp1(1:10,linspace(-0.4,0,10),   x(4),'nearest');
    x23 = interp1(1:10,linspace(-0.4,0,10),   x(5),'nearest');
    x45 = interp1(1:10,linspace(-0.4,0,10),   x(6),'nearest');

    %% Assign the parameters to the vehicle model
    Vehicle.Chassis.SuspA1.Simple.Heave.K.Value = c1;
    Vehicle.Chassis.SuspA3.Simple.Heave.K.Value = c23;
    Vehicle.Chassis.SuspA2.Simple.Heave.K.Value = c23;
    Trailer.Chassis.SuspA1.Simple.Heave.K.Value = c45;
    Trailer.Chassis.SuspA2.Simple.Heave.K.Value = c45;

    Vehicle.Chassis.SuspA1.Simple.Heave.xInit.Value = x1;    
    Vehicle.Chassis.SuspA2.Simple.Heave.xInit.Value = x23;  
    Vehicle.Chassis.SuspA3.Simple.Heave.xInit.Value = x23;    
    Trailer.Chassis.SuspA1.Simple.Heave.xInit.Value = x45;
    Trailer.Chassis.SuspA2.Simple.Heave.xInit.Value = x45;

    assignin('base','Trailer',Trailer);
    assignin('base','Vehicle',Vehicle);

    %% Simulate
    out = sim("sm_car_Axle3");

    %% Derive the final deformation of the suspension
    defA1 = out.simlog_sm_car.Vehicle.Vehicle.Chassis.SuspA1.Simple.Susp.Prismatic_Heave.Pz.p.series.values;
    defA2 = out.simlog_sm_car.Vehicle.Vehicle.Chassis.SuspA2.Simple.Susp.Prismatic_Heave.Pz.p.series.values;
    defA3 = out.simlog_sm_car.Vehicle.Vehicle.Chassis.SuspA3.Simple.Susp.Prismatic_Heave.Pz.p.series.values;
    defA4 = out.simlog_sm_car.Vehicle.Trailer.Trailer.Chassis.SuspA1.Simple.Susp.Prismatic_Heave.Pz.p.series.values;
    defA5 = out.simlog_sm_car.Vehicle.Trailer.Trailer.Chassis.SuspA2.Simple.Susp.Prismatic_Heave.Pz.p.series.values;

    % Objective: Reduce the square sum of all deformations 
    response  =defA1(end)^2 + defA2(end)^2 + defA3(end)^2+ defA4(end)^2 + defA5(end)^2;
end
