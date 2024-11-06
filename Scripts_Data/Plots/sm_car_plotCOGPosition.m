function sm_car_plotCOGPosition()
%% Description: 
% This code plots the position and orientation of the cabin with respect to
% the reference coordinate system provided for the chassis. Please note
% that the value shown here are relative to the chassis and do not refer to
% the world frame

% If the vehicle was simulated with a rigid cabin, this function will not
% work

%% 1) Retrieve the data
try logsout_sm_car = evalin('base','logsout_sm_car');
catch; disp('There are no results to be plotted; Simulate the model first'); return; end

% Check that there are cabin results available for the plot
try logsout_cabin = logsout_sm_car.get('cogCabin');
catch; disp('No Cabin Info available. Ensure that the cabin model is active'); return; end

% Collect the simulation data for the cabin
simTime = logsout_cabin.Values.px.Time;      % in sec
data{1}  = logsout_cabin.Values.px.Data;     % in m
data{2}  = logsout_cabin.Values.py.Data;     % in m
data{3} = logsout_cabin.Values.pz.Data;      % in m
data{4} = logsout_cabin.Values.angx.Data;    % in rad
data{5}= logsout_cabin.Values.angy.Data;     % in rad
data{6} = logsout_cabin.Values.angz.Data;    % in rad


%% 2) Plot result
figure('Units','centimeters','Color','w','Position',[0,0,20,12.91]);
tiledlayout(3, 2, 'Padding', 'compact', 'TileSpacing', 'compact');

% Labels that will be use for figures 1 to 6
titleLabels = {'Relative X Position','Relative Y Position','Relative Z Position','Relative Roll Angle','Relative Pitch Angle','Relative Yaw Angle'};
yLabels     = {'Position in m','Position in m','Position in m','Angle in rad','Angle in rad','Angle in rad'};

% Plot the results
for i= 1:6
    nexttile;

    % Plot the data
    plot(simTime,data{i},'Color','b','LineWidth',1.5);
    
    % Add the labels and title
    xlabel('Time in sec');
    ylabel(yLabels{i});
    title(titleLabels{i});
    grid on;

    % Make the text bigger;
    ax=gca; ax.FontSize =  11.5;

end

end