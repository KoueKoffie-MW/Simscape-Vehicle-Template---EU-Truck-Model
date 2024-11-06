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

% Parametrize the model
truckCabinModelData;

%% 2) Simulate
% Simulate and collect results
out = sim('truckCabinModel.slx');

% Data of the position of COG
estimatedCOG = out.logsout.get('cogCabin');


deg_factor = 180/pi;

figure('Color','w');
subplot(2,1,1);
plot(estimatedCOG.Values.angx.Time, deg_factor*estimatedCOG.Values.angx.Data, 'LineWidth',1.5,'Color','b');
hold on;
plot(cabin_reference.time, deg_factor*(cabin_reference.roll - chassis_reference.roll),'LineWidth',1.5,'Color','r');
grid on;
legend('Estimated', 'Measured'); title('Roll angle');
xlabel('Time in sec'); ylabel('Angle in °');

subplot(2,1,2); 
plot(estimatedCOG.Values.angy.Time, deg_factor*estimatedCOG.Values.angy.Data,'LineWidth',1.5,'Color','b');
hold on;
plot(cabin_reference.time, deg_factor*(cabin_reference.pitch - chassis_reference.pitch),'LineWidth',1.5,'Color','r');
grid on;
legend('Estimated', 'Measured'); title('Ptich angle');
xlabel('Time in sec');
ylabel('Angle in °'); 