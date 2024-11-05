%% Description:
% Loads the data need to simulate truckCabinModel
%% Load the Vehicle Data:
load('Vehicle.mat');

% Validation data provided by the customer
load('20240719_152312.mat');

Vehicle = sm_car_param_cabin(Vehicle);
Cabin = Vehicle.Chassis.Body.Cabin;

%% Process the measured data
cabin_input.time = (data.se_imu_cabin_xsens_mti_680g_can_tego.timestamp - data.se_imu_cabin_xsens_mti_680g_can_tego.timestamp(1)) * 1e-9;

cabin_input.acc_x = data.se_imu_cabin_xsens_mti_680g_can_tego.m_oEgoDynamic_f64Ax;
cabin_input.acc_y = data.se_imu_cabin_xsens_mti_680g_can_tego.m_oEgoDynamic_f64Ay;
cabin_input.acc_z = data.se_imu_cabin_xsens_mti_680g_can_tego.m_oEgoDynamic_f64Az;

cabin_reference.time = (data.se_adma_cabin_tego.timestamp - data.se_adma_cabin_tego.timestamp(1)) * 1e-9;
cabin_reference.roll = data.se_adma_cabin_tego.m_oEgoDynamic_f64Roll;
cabin_reference.pitch = data.se_adma_cabin_tego.m_oEgoDynamic_f64Pitch;

chassis_reference.time = (data.se_oxts_rt3k_ego.timestamp - data.se_oxts_rt3k_ego.timestamp(1))*1e-9;
chassis_reference.roll = data.se_oxts_rt3k_ego.m_oEgoDynamic_f64Roll;
chassis_reference.pitch = data.se_oxts_rt3k_ego.m_oEgoDynamic_f64Pitch;
