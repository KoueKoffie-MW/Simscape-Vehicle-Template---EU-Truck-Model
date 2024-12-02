%% Description:
% This script is used to validate the cabin model with a set of measured
% vehicle acceleration and angle. The validation performed here can be use
% as a sanity check to ensure a realistic implementation. 

% The measurement contains the acceleration and angular position of the
% vehicle during a test-drive. The acceleration will be assigned to the
% Simscape Multibody model for the X, Y and Z direction. As a result, the
% pitch and roll angle derived by the Simscape model will be compared with
% the measured pitch and roll angle. 

%% 1) Set up model
% Free workspace
clear

% Name of the cabin Harness model
modelName = 'truckCabinModel';  

% Parametrize the model
truckCabinModelData;

% Check if the model is loaded. If not open it
if ~bdIsLoaded(modelName); open_system(modelName); end

%% 2) Simulate
% Simulate and collect results
out = sim(modelName);

% Data of the position of COG
estimatedCOG = out.logsout.get('cogCabin');

% Conversion factor between rad and deg
deg_factor = 180/pi;

%% 3) Plot and compare
% Create figure
figure('Units','centimeters','Color','w','Position',[0,0,20,12.91]);
tiledlayout(2, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

% Compare estimated and real roll angle
nexttile
plot(estimatedCOG.Values.angx.Time, deg_factor*estimatedCOG.Values.angx.Data, 'LineWidth',1.5,'Color','b');
hold on;
plot(cabin_reference.time, deg_factor*(cabin_reference.roll - chassis_reference.roll),'LineWidth',1.5,'Color','r');
grid on;
legend('Estimated', 'Measured'); title('Roll angle');
xlabel('Time in sec'); ylabel('Angle in °');

% Compare estimated and real pitch angle
nexttile;
plot(estimatedCOG.Values.angy.Time, deg_factor*estimatedCOG.Values.angy.Data,'LineWidth',1.5,'Color','b');
hold on;
plot(cabin_reference.time, deg_factor*(cabin_reference.pitch - chassis_reference.pitch),'LineWidth',1.5,'Color','r');
grid on;
legend('Estimated', 'Measured'); title('Ptich angle');
xlabel('Time in sec'); ylabel('Angle in °'); 