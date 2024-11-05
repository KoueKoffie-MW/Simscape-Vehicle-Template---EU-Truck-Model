%% Description:
% Temporary solution for validation 

%% Load the Vehicle Data:
truckCabinModelData;

sim('truckCabinModel.slx');

%% Simulate the model and collect the results:
estimatedCOG = out.logsout.get('cogCabin');

deg_factor = 180/pi;

figure;
subplot(2,1,1);
plot(estimatedCOG.Values.angx.Time, deg_factor*estimatedCOG.Values.angx.Data);
hold on;
plot(cabin_reference.time, deg_factor*(cabin_reference.roll - chassis_reference.roll));
grid minor;
legend('estimated cabin roll angle', 'reference cabin roll angle relative to chassis');
xlabel('time, s');
ylabel('angle, degrees');

subplot(2,1,2);
plot(estimatedCOG.Values.angy.Time, deg_factor*estimatedCOG.Values.angy.Data);
hold on;
plot(cabin_reference.time, deg_factor*(cabin_reference.pitch - chassis_reference.pitch));
grid minor;
legend('estimated cabin pitch angle', 'reference cabin pitch angle relative to chassis');
xlabel('time, s');
ylabel('angle, degrees');



% run_easy;