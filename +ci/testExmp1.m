function testExmp1()
%% Description:
% Testing script to be used in the CI/CD Pipeline. Checks whether the WOT
% scenario passes without any errors

% Get all the variable in the MATLAB workspace: 
baseVars = evalin('base', 'who');

% Iterate over each variable
for i = 1:length(baseVars)

    varName = baseVars{i};

    % Get the variable's value from the base workspace
    varValue = evalin('base', varName);
    
    % Assign the variable to the function's workspace
    eval([varName,'=varValue;'])
end


% First run the script for example 1 to see if it works:
disp('Running WOT with plane road');
setupWideOpenBraking;
disp('WOT with plane road passed');

% Now test also with CRG
disp('Running WOT with CRG road')
sm_car_config_road('sm_car_Axle3','crg rough road');
sim('sm_car_Axle3');
disp('WOT with CRG road passed');

close all;
end