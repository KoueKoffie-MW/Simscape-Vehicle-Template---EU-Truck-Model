function [damperFront,springFront,damperRear,springRear] = loadLUTs()
%% Description: 
% Load the look up table to model spring and damper behavior at the rear
% and front axle. The spring and damper behavior on the same axle is equal
% for the right and the left side.

% The data was taken from the MATLAB function provided by EFS

%% 1) DAMPER FRONT
% Damper map expressed as speed (in m/s) vs. force in N
damperFront = [-0.390, -3960.0;
               -0.260, -2390.0;
               -0.130, -1270.0;
               -0.052,  -300.0;
                0    ,     0  ;
                0.052,   200.0;
                0.130,   550.0;
                0.260,  1320.0;
                0.390,  2060.0];

%% 2) SPRING FRONT WITH PRE-LOAD
% Spring map expressed as displacement in m vs. force in N
springFront = [-0.040, -1000.0;
               -0.037, 2500.0;
                0.000, 3000.0;
                0.010, 3400.0;
                0.020, 4000.0;
                0.025, 4500.0;
                0.030, 5700.0;
                0.035, 9000.0];

%% 3) DAMPER REAR
% Damper map expressed as speed (in m/s) vs. force in N
damperRear      = [-0.390,   -2340.0; ...
                   -0.260,   -1820.0; ...
                   -0.130,    -720.0; ...
                   -0.052,    -160.0; ...
                    0.000,       0.0; ...
                    0.052,      80.0; ...
                    0.130,     170.0; ...
                    0.260,     420.0; ...
                    0.390,     660.0 ];

%% 4) SPRING REAR WITH PRE-LOAD
% Spring map expressed as displacement in m vs. force in N
springRear      = [-0.040,   -2000.0; ...
                   -0.030,    2600.0; ... 
                   -0.020,    2725.0; ...
                    0.000,    3000;... 
                    0.010,    3200.0; ...
                    0.017,    3350.0; ...
                    0.030,    4450.0; ...
                    0.035,    5100.0; ...
                    0.040,    7000.0 ]; % N/m   
end