function testExmp1()
% This script was created for pipeline purposes to test the modification
% on the repository directly in Gitlab

% First run the script for example 1 to see if it works:
controlledChargingExample;
disp('Example 1: Live script run without any problem')

% After the first run, check the plot function and see if it runs smoothly
controlledChargingPlotSOC; 
disp('Example 1: Plot function run correctly')

bdclose
end