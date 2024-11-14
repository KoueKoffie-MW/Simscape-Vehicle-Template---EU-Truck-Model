%% Description:
% This script loads the vehicle data (the vehicle dimensions) as well as
% the measured data from a test-drive. The vehicle data is used to
% parametrize the cabin model while the measured data is used to assign
% the measured accelerations to the model


%% Load the Vehicle Data:
load('Vehicle.mat');                   % Dimensions of the vehicle
Vehicle = sm_car_param_cabin(Vehicle); % Cabin dimensions
Cabin = Vehicle.Chassis.Body.Cabin;    % Cabin dimension variable used in the model

%% Load test-drive data:
% Test drive performed on the vehicle:
load('20240719_152312.mat');

% Timestamp used for the measurement data in sec
cabin_input.time = (data.se_imu_cabin_xsens_mti_680g_can_tego.timestamp - data.se_imu_cabin_xsens_mti_680g_can_tego.timestamp(1)) * 1e-9;

% Acceleration over time for X, Y, and Z (In m/s^2)
cabin_input.acc_x = data.se_imu_cabin_xsens_mti_680g_can_tego.m_oEgoDynamic_f64Ax;
cabin_input.acc_y = data.se_imu_cabin_xsens_mti_680g_can_tego.m_oEgoDynamic_f64Ay;
cabin_input.acc_z = data.se_imu_cabin_xsens_mti_680g_can_tego.m_oEgoDynamic_f64Az;

% Pitch and Roll angles in rad
cabin_reference.time = (data.se_adma_cabin_tego.timestamp - data.se_adma_cabin_tego.timestamp(1)) * 1e-9;
cabin_reference.roll = data.se_adma_cabin_tego.m_oEgoDynamic_f64Roll;
cabin_reference.pitch = data.se_adma_cabin_tego.m_oEgoDynamic_f64Pitch;
chassis_reference.time = (data.se_oxts_rt3k_ego.timestamp - data.se_oxts_rt3k_ego.timestamp(1))*1e-9;
chassis_reference.roll = data.se_oxts_rt3k_ego.m_oEgoDynamic_f64Roll;
chassis_reference.pitch = data.se_oxts_rt3k_ego.m_oEgoDynamic_f64Pitch;
