function testExmp2()
% This script was created for pipeline purposes to test the modification
% on the repository directly in Gitlab

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

% First run the script for example 2 to see if it works:
setupDoubleLaneChange;
disp('Example 2: Live script run without any problem')

end