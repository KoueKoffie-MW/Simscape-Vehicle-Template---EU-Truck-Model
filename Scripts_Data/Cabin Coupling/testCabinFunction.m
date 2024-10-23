%% This script tests the MATLAB function for calculating the cabin angles:
% All results are stored in the B matrix that contains the following
% values (more information in the PDF documentation):
% B =[𝜙 𝜃 𝜑 𝜙̇ 𝜃̇ 𝜑̇ 𝑑𝑥 𝑑𝑦 𝑑𝑧 𝑑𝑥̇ 𝑑𝑦̇ 𝑑𝑧̇]

% For the initialization we set all the value of B to zero:
B_old = zeros(1,12);

% And here the simulation time. Value greater than 0.05 proved unstable!
dT         = 0.001;
simTime    = 0:dT:10;

% Here the user can select the values of acceleration measured by the IMU
C_AccX_IMU = (simTime >= 5  & simTime <= 10);
C_AccY_IMU = (simTime >= 15 & simTime <= 20);
C_AccZ_IMU = (simTime >= 25 & simTime <= 30);

% State Vector
B=zeros(numel(simTime),12);

% Calculate the new state
for i=1:numel(simTime)
    B(i,:) = MAN_Cabin(B_old, C_AccX_IMU(i), C_AccY_IMU(i), C_AccZ_IMU(i), dT);
    B_old = B(i,:);
end
%% 

% Plot the signals applied 
fHandle = setfigure();
subplot(2,1,1); grid on; hold on; 
plot(simTime, C_AccX_IMU,'LineWidth',2);
plot(simTime, C_AccY_IMU,'LineWidth',2);
plot(simTime, C_AccZ_IMU,'LineWidth',2);
legend('IMU Ax','IMU Ay','IMU Az');xlabel('Time in sec');ylabel('Acceleration in m/s^2'); set(gca,'FontSize',15);

% Plot 
subplot(2,1,2); grid on; hold on; 
plot(simTime,B(:,9),'LineWidth',2); xlabel('Time in sec'); ylabel('Disp Z in m');set(gca,'FontSize',15);

%% 
fHandle = setfigure();

% Visualize the data: 
subplot(3,1,1); grid on;
plot(simTime,B(:,9),'LineWidth',2); xlabel('Time in sec'); ylabel('Disp Z in m');

% Visualize the data: 
subplot(3,1,2); grid on;
plot(simTime,B(:,1),'LineWidth',2); xlabel('Time in sec'); ylabel('Phi in rad');

% Visualize the data: 
subplot(3,1,3); grid on;
plot(simTime,B(:,2),'LineWidth',2); xlabel('Time in sec'); ylabel('Theta in rad');



%% Subfunctions
function fHandle = setfigure()

fHandle = figure('Units','centimeters','Position',[0,0,29.92,12.91],'Color','w');
ax= gca; 
ax.FontSize = 30;

end
