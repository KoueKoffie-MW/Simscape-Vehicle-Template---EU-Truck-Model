%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%									 ___                                    
%								   /,___)                                   
%						  __    _ | (__   ___                               
%						/ ,__`\(_)| ,__)/,, __)                             
%					   (  ___ / _ | |   \__, \                              
%					   `\____) (_)(_)   (____/                              
%                                                                         
%                        e:fs TechHub GmbH                                
%                         www.efs-auto.com                                
%-------------------------------------------------------------------------
%     Copyright (c) 2022 e:fs TechHub GmbH. All rights reserved.     
%-------------------------------------------------------------------------
%
% Date:        11-Oct-2022
% Project:     EPaL - Ego-Vehicle Perception and Localization
% Author:      Michael Gentner EFS-GX2 (michael.gentner@efs-auto.de)
%
% Description: MAN Cabin Model V1.0 - only concept
%
% coordinate systems
%
% I = initial system
% B = bodyfixed coordinate system body
% C = bodyfixed coordinate system cabin
%
% rotation matrix   = A
%
% I_A_B             = rotation matrix to rotate from B to I.
% B_A_I             = rotation matrix to rotate from I to B.
% B_A_C             = rotation matrix to rotate from C to B.
% C_A_B             = rotation matrix to rotate from B to C.
%
% position vector   = r
% 
% B_r_BC            = moved position vector from origin B to origin C, given in B 
% B_r0_BC           = fixed position vector from origin B to origin C, given in B 
%     
% B_r0_BBsdfl       = fixed attach point spring damper front left at body, given in B 
% B_r0_BCsdfl       = fixed attach point spring damper front left at cabin, given in B
% B_r_BCsdfl        = moved attach point spring damper front left at cabin, given in B
% B_r_BsdflCsdfl    = moves postiton vetor from attach point spring damper front left at body to cabin, given in B
% B_e_sdfl          = direction vector of B_r_BsdflCsdfl, given in B 
% B_u_sdfl          = suspension length front left, given in B 
% B_v_sdfl          = suspension velocity front left, given in B 
%
% B_r0_BBsdfr       = fixed movedattach point spring damper front right at body, given in B 
% B_r0_BCsdfr       = fixed attach point spring damper front right at cabin, given in B 
% B_r_BCsdfr        = moved attach point spring damper front right at cabin, given in B
% B_r_BsdfrCsdfr    = moves postiton vetor from attach point spring damper front right at body to cabin, given in B
% B_e_sdfr          = direction vector of B_r_BsdfrCsdfr, given in B 
% B_u_sdfr          = suspension length front right, given in B 
% B_v_sdfr          = suspension velocity front right, given in B 
%
% B_r0_BBsdrl       = fixed moved attach point spring damper rear left at body, given in B 
% B_r0_BCsdrl       = fixed attach point spring damper rear left at cabin, given in B 
% B_r_BCsdrl        = moved attach point spring damper rear left at cabin, given in B
% B_r_BsdrlCsdrl    = moves postiton vetor from attach point spring damper rear left at body to cabin, given in B
% B_e_sdrl          = direction vector of B_r_BsdrlCsdrl, given in B 
% B_u_sdrl          = suspension length rear left, given in B 
% B_v_sdrl          = suspension velocity rear left, given in B
%
% B_r0_BBsdrr       = fixed moved attach point spring damper rear right at body, given in B 
% B_r0_BCsdrr       = fixed attach point spring damper rear right at cabin, given in B 
% B_r_BCsdrr        = moved attach point spring damper rear right at cabin, given in B
% B_r_BsdrrCsdrr    = moves postiton vetor from attach point spring damper rear right at body to cabin, given in B
% B_e_sdrr          = direction vector of B_r_BsdrrCsdrr, given in B 
% B_u_sdrr          = suspension length rear right, given in B 
% B_v_sdrr          = suspension velocity rear right, given in B 
%
% C_r0_CCsdfl       = fixed attach point spring damper front left at cabin, given in C
% C_r0_CCsdfr       = fixed attach point spring damper front right at cabin, given in C
% C_r0_CCsdrl       = fixed attach point spring damper rear left at cabin, given in C
% C_r0_CCsdrr       = fixed attach point spring damper rear right at cabin, given in C
%   
% state vector      = x
%
% C_roll            = roll angle
% C_pitch           = pitch angle
% C_yaw             = yaw angle
% C_roll_p          = roll rate
% C_pitch_p         = pitch rate
% C_yaw_p           = yaw rate
% C_dx              = delta x-position of origin C to B
% C_dy              = delta y-position of origin C to B
% C_dz              = delta z-position of origin C to B
% C_dx_p            = x-velocity of origin C
% C_dy_p            = y-velocity of origin C
% C_dz_p            = z-velocity of origin C
%
% ToDos
% - import parameter via struct and parameter file
% - add position vector and rotation matrix of IMU input and reference signals
% - add roll and pitch pol to calculation
% - find concepts for better reference data
% - calculate spring and damper characteristics ones, not every timestep
% - !!! swing arms are modelled as force elements, have to be changed to guide elements !!!
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function B_x = MAN_Cabin(B_x_old, C_AccX_IMU, C_AccY_IMU, C_AccZ_IMU, dT)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% constants
    g = 9.81; % m/s^2 
    mCabin = 1242.63; % kg
    
    FS_fl = [  -0.040,   -1000.0; ...
               -0.037,    2500.0; ...
                0.000,    3000.0; ...
                0.010,    3400.0; ...
                0.020,    4000.0; ...
                0.025,    4500.0; ...
                0.030,    5700.0; ...
                0.035,    9000.0 ]; % N/m

    FS_rl = [  -0.040,   -2000.0; ...
               -0.030,    2600.0; ...
               -0.020,    2725.0; ...
                0.000,    3000.0; ...
                0.010,    3200.0; ...
                0.017,    3350.0; ...
                0.030,    4450.0; ...
                0.035,    5100.0; ...
                0.040,    7000.0 ]; % N/m   

    FS_fr = FS_fl; % N/m
    FS_rr = FS_rl; % N/m

    FD_fl = [  -0.390,   -3960.0; ...
               -0.260,   -2390.0; ...
               -0.130,   -1270.0; ...
               -0.052,    -300.0; ...
                0.000,       0.0; ...
                0.052,     200.0; ...
                0.130,     550.0; ...
                0.260,    1320.0; ...
                0.390,    2060.0 ]; % Ns/m
    
    FD_rl = [  -0.390,   -2340.0; ...
               -0.260,   -1820.0; ...
               -0.130,    -720.0; ...
               -0.052,    -160.0; ...
                0.000,       0.0; ...
                0.052,      80.0; ...
                0.130,     170.0; ...
                0.260,     420.0; ...
                0.390,     660.0 ];
                
    FD_fr = FD_fl; % Ns/m
    FD_rr = FD_rl; % Ns/m

    cSwingArm   = 25000;%50000; %N/m
    
    cRollBarLin = 35000;%35000;
    cRollBarTors= 10000;%50000;
    cRollBarLat = 20000;%50000; % N/m
    
    C_Jxx = 1490.0; % kgm^2        
    C_Jyy = 1273.0; % kgm^2
    C_Jzz = 1476.4; % kgm^2
       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% old state vector
    roll      = B_x_old(1);
    pitch     = B_x_old(2);
    yaw       = B_x_old(3);
    roll_p    = B_x_old(4);
    pitch_p   = B_x_old(5);
    yaw_p     = B_x_old(6);
    B_dx      = B_x_old(7);
    B_dy      = B_x_old(8);
    B_dz      = B_x_old(9);
    B_dx_p    = B_x_old(10);
    B_dy_p    = B_x_old(11);
    B_dz_p    = B_x_old(12);
    
    B_v_BC   = [B_dx_p; B_dy_p; B_dz_p]; 
    B_om_BC  = [roll_p; pitch_p; yaw_p];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% rotation matrx - euler angles - zyx convention 
    % single turn alone z-axle
    B_A_Cz = [cos(yaw) -sin(yaw) 0;
              sin(yaw) cos(yaw)  0;
                0           0        1];

    % single turn alone y-axle
    B_A_Cy = [cos(pitch)  0 sin(pitch);
                  0         1     0 ;
              -sin(pitch) 0 cos(pitch)];

    % single turn alone x-axle
    B_A_Cx = [1     0            0;
              0 cos(roll) -sin(roll);
              0 sin(roll) cos(roll)];
        
    B_A_C = B_A_Cz * B_A_Cy * B_A_Cx;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% positon vector [m]
    % position vector from origin B to origin C
    B_r_BC = [0.4969+B_dx;  0.000+B_dy;  1.5704+B_dz];
    B_r0_BC = [0.4969;  0.000;  1.5704];
    
    % attach point spring damper front left at body and cabin
    B_r0_BBsdfl = [ 1.3250;  0.6550;  0.2190];
    B_r0_BCsdfl = [ 1.3250;  0.6550;  0.5540];
    
    % attach point spring damper front right at body and cabin
    B_r0_BBsdfr = [ 1.3250; -0.6550;  0.2190];
    B_r0_BCsdfr = [ 1.3250; -0.6550;  0.5540];
    
    % attach point spring damper rear left at body and cabin
    B_r0_BBsdrl = [-0.4750;  0.5250;  0.2045];
    B_r0_BCsdrl = [-0.4750;  0.6000;  0.4950];
    
    % attach point spring damper rear left at body and cabin
    B_r0_BBsdrr = [-0.4750; -0.5250;  0.2045];
    B_r0_BCsdrr = [-0.4750; -0.6000;  0.4950];
    
    % attach point swing arm rear left at body and cabin
    B_r0_BBsarl  = [ -0.4750;  0.3500;  0.5600 ];
    B_r0_BCsarl  = [ -0.4750;  0.6000;  0.5750 ];
    
    % attach point swing arm rear right at body and cabin
    B_r0_BBsarr  = [ -0.4750; -0.3500;  0.5600 ];
    B_r0_BCsarr  = [ -0.4750; -0.6000;  0.5750 ];

    % attach point anti roll bar "torsional" front left at body and cabin
    B_r0_BBrbtfl  = [  1.0350;  0.5050;  0.5960 ];
    B_r0_BCrbtfl  = [  1.3850;  0.5764;  0.6100 ];
    
    % attach point anti roll bar "torsional" front right at body and cabin
    B_r0_BBrbtfr  = [  1.0350; -0.5050;  0.5960 ];
    B_r0_BCrbtfr  = [  1.3850; -0.5764;  0.6100 ];
    
    % attach point anti roll bar "lateral" front left at body and cabin
    B_r0_BBrblfl  = [  1.3850;  0.0000;  0.6100 ];
    B_r0_BCrblfl  = [  1.3850;  0.5764;  0.6100 ];
    
    % attach point anti roll bar "lateral" front right at body and cabin
    B_r0_BBrblfr  = [  1.3850;  0.0000;  0.6100 ];
    B_r0_BCrblfr  = [  1.3850; -0.5764;  0.6100 ];
    
    % all above given in C
    C_r0_CCsdfl = (B_r0_BCsdfl  - B_r0_BC);
    C_r0_CCsdfr = (B_r0_BCsdfr  - B_r0_BC);   
    C_r0_CCsdrl = (B_r0_BCsdrl  - B_r0_BC);
    C_r0_CCsdrr = (B_r0_BCsdrr  - B_r0_BC); 
    
    C_r0_CCsarl = (B_r0_BCsarl  - B_r0_BC); 
    C_r0_CCsarr = (B_r0_BCsarr  - B_r0_BC);
    
    C_r0_CCrbtfl = (B_r0_BCrbtfl  - B_r0_BC); 
    C_r0_CCrbtfr = (B_r0_BCrbtfr  - B_r0_BC);
    
    C_r0_CCrblc = (B_r0_BBrblfl  - B_r0_BC);
    C_r0_CCrblfl = (B_r0_BCrblfl  - B_r0_BC); 
    C_r0_CCrblfr = (B_r0_BCrblfr  - B_r0_BC);
          
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% motion at attach point spring damper front left 
    B_r_BCsdfl = B_r_BC + B_A_C * C_r0_CCsdfl;
    B_r_CsdflBsdfl = B_r0_BBsdfl - B_r_BCsdfl;
    B_e_sdfl  = B_r_CsdflBsdfl/norm(B_r_CsdflBsdfl);
    
    B_u_sdfl = norm(B_r_CsdflBsdfl) - norm(B_r0_BCsdfl-B_r0_BBsdfl);

    B_v_sdfl = B_e_sdfl' * -(B_v_BC + cross(B_om_BC, B_A_C*C_r0_CCsdfl)); 
        
    % motion at attach point spring damper front right 
    B_r_BCsdfr = B_r_BC + B_A_C * C_r0_CCsdfr;
    B_r_CsdfrBsdfr = B_r0_BBsdfr - B_r_BCsdfr;
    B_e_sdfr  = B_r_CsdfrBsdfr/norm(B_r_CsdfrBsdfr);
    
    B_u_sdfr = norm(B_r_CsdfrBsdfr) - norm(B_r0_BCsdfr-B_r0_BBsdfr);
    
    B_v_sdfr = B_e_sdfr' * -(B_v_BC + cross(B_om_BC, B_A_C*C_r0_CCsdfr));
    
    % motion at attach point spring damper rear left 
    B_r_BCsdrl = B_r_BC + B_A_C * C_r0_CCsdrl;
    B_r_CsdrlBsdrl = B_r0_BBsdrl - B_r_BCsdrl;
    B_e_sdrl  = B_r_CsdrlBsdrl/norm(B_r_CsdrlBsdrl);
    
    B_u_sdrl = norm(B_r_CsdrlBsdrl) - norm(B_r0_BCsdrl-B_r0_BBsdrl);
    
    B_v_sdrl = B_e_sdrl' * -(B_v_BC + cross(B_om_BC, B_A_C*C_r0_CCsdrl));
    
    % motion at attach point spring damper rear right
    B_r_BCsdrr = B_r_BC + B_A_C * C_r0_CCsdrr;
    B_r_CsdrrBsdrr = B_r0_BBsdrr - B_r_BCsdrr;
    B_e_sdrr  = B_r_CsdrrBsdrr/norm(B_r_CsdrrBsdrr);
    
    B_u_sdrr = norm(B_r_CsdrrBsdrr) - norm(B_r0_BCsdrr-B_r0_BBsdrr);
    
    B_v_sdrr = B_e_sdrr' * -(B_v_BC + cross(B_om_BC, B_A_C*C_r0_CCsdrr));
    
    % motion at attach point swing arm rear left 
    B_r_BCsarl = B_r_BC + B_A_C * C_r0_CCsarl;
    B_r_CsarlBsarl = B_r0_BBsarl - B_r_BCsarl;
    B_e_sarl  = B_r_CsarlBsarl/norm(B_r_CsarlBsarl);
    
    B_u_sarl = norm(B_r_CsarlBsarl) - norm(B_r0_BCsarl-B_r0_BBsarl);
    
    % motion at attach point swing arm rear right 
    B_r_BCsarr = B_r_BC + B_A_C * C_r0_CCsarr;
    B_r_CsarrBsarr = B_r0_BBsarr - B_r_BCsarr;
    B_e_sarr  = B_r_CsarrBsarr/norm(B_r_CsarrBsarr);
    
    B_u_sarr = norm(B_r_CsarrBsarr) - norm(B_r0_BCsarr-B_r0_BBsarr);  

    % motion at attach point anti roll bar "lateral" front left 
    B_r_BCrblfl = B_r_BC + B_A_C * C_r0_CCrblfl;
    B_r_BCrblc = B_r_BC + B_A_C * C_r0_CCrblc;
    B_r_CrblflBrblfl = B_r_BCrblc - B_r_BCrblfl;
    B_e_rblfl  = B_r_CrblflBrblfl/norm(B_r_CrblflBrblfl);
    
    B_u_rblfl = norm(B_r_CrblflBrblfl) - norm(B_r0_BCrblfl-B_r0_BBrblfl);
    
    % motion at attach point anti roll bar "lateral" front right 
    B_r_BCrblfr = B_r_BC + B_A_C * C_r0_CCrblfr;
    B_r_CrblfrBrblfr = B_r_BCrblc - B_r_BCrblfr;
    B_e_rblfr  = B_r_CrblfrBrblfr/norm(B_r_CrblfrBrblfr);
    
    B_u_rblfr = norm(B_r_CrblfrBrblfr) - norm(B_r0_BCrblfr-B_r0_BBrblfr);
    
    % motion at attach point anti roll bar "torsional" front left
    B_r_BCrbtfl = B_r_BC + B_A_C * C_r0_CCrbtfl;
    B_r_CrbtflBrbtfl = B_r0_BBrbtfl - B_r_BCrbtfl;
    B_e_rbtfl  = B_r_CrbtflBrbtfl/norm(B_r_CrbtflBrbtfl);
    
    B_u_rbtfl = norm(B_r_CrbtflBrbtfl) - norm(B_r0_BCrbtfl-B_r0_BBrbtfl);  
    
    % motion at attach point anti roll bar "torsional" front right
    B_r_BCrbtfr = B_r_BC + B_A_C * C_r0_CCrbtfr;
    B_r_CrbtfrBrbtfr = B_r0_BBrbtfr - B_r_BCrbtfr;
    B_e_rbtfr  = B_r_CrbtfrBrbtfr/norm(B_r_CrbtfrBrbtfr);
    
    B_u_rbtfr = norm(B_r_CrbtfrBrbtfr) - norm(B_r0_BCrbtfr-B_r0_BBrbtfr);  
    
    % motion at attach point anti roll bar front left
    B_r_BCrbfl = B_r_BC + B_A_C * C_r0_CCrblfl;
    B_r_CrbflBrbfl = B_r0_BCrblfl - B_r_BCrbfl + rand()*1e-17;

    B_u_rbfl = norm(B_r_CrbflBrbfl);
 
    % motion at attach point anti roll bar front right
    B_r_BCrbfr = B_r_BC + B_A_C * C_r0_CCrblfr;
    B_r_CrbfrBrbfr = B_r0_BCrblfr - B_r_BCrbfr - rand()*1e-17;

    B_u_rbfr = norm(B_r_CrbfrBrbfr);
    
    B_e_rbfl  = (B_r_CrbflBrbfl-B_r_CrbfrBrbfr)/norm(B_r_CrbflBrbfl-B_r_CrbfrBrbfr);
    B_e_rbfr  = (B_r_CrbfrBrbfr-B_r_CrbflBrbfl)/norm(B_r_CrbfrBrbfr-B_r_CrbflBrbfl);
    
    % lever arm front and rear
    leverFront = [0; 0; abs(C_r0_CCsdrr(1))/(abs(C_r0_CCsdrr(1))+abs(C_r0_CCsdfr(1)))];
    leverRear  = [0; 0; abs(C_r0_CCsdfr(1))/(abs(C_r0_CCsdrr(1))+abs(C_r0_CCsdfr(1)))];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Force at attach point spring damper front left
    F_Static_sdfl  = [0; 0; g * mCabin/2] .* leverFront;
    F_Spring_sdfl  = getInterpolatedForce(FS_fl,B_u_sdfl);
    F_Damper_sdfl  = getInterpolatedForce(FD_fl,B_v_sdfl);

    F_sdfl = F_Static_sdfl + B_e_sdfl*F_Spring_sdfl + B_e_sdfl*F_Damper_sdfl;
    
    % Force at attach point spring damper front right
    F_Static_sdfr  = [0; 0; g * mCabin/2] .* leverFront;
    F_Spring_sdfr  = getInterpolatedForce(FS_fr,B_u_sdfr);
    F_Damper_sdfr  = getInterpolatedForce(FD_fr,B_v_sdfr);
    
    F_sdfr = F_Static_sdfr + B_e_sdfr*F_Spring_sdfr + B_e_sdfr*F_Damper_sdfr;
    
    % Force at attach point spring damper rear left
    F_Static_sdrl   = [0; 0; g * mCabin/2] .* leverRear;
    F_Spring_sdrl   = getInterpolatedForce(FS_rl,B_u_sdrl);
    F_Damper_sdrl   = getInterpolatedForce(FD_rl,B_v_sdrl);
    
    F_sdrl   = F_Static_sdrl + B_e_sdrl*F_Spring_sdrl + B_e_sdrl*F_Damper_sdrl;

    % Force at attach point spring damper rear right
    F_Static_sdrr   = [0; 0; g * mCabin/2] .* leverRear;
    F_Spring_sdrr   = getInterpolatedForce(FS_rr,B_u_sdrr);
    F_Damper_sdrr   = getInterpolatedForce(FD_rr,B_v_sdrr);

    F_sdrr   =  F_Static_sdrr + B_e_sdrr*F_Spring_sdrr + B_e_sdrr*F_Damper_sdrr;

    % Force at attach point swing arm rear left
    F_sarl = B_e_sarl * B_u_sarl * cSwingArm;
      
    % Force at attach point swing arm rear right
    F_sarr = B_e_sarr * B_u_sarr * cSwingArm;

    % Force at attach point anti roll bar "torsional" front left
    F_rbtfl = B_e_rbtfl * B_u_rbtfl * cRollBarTors;
    
    % Force at attach point anti roll bar "torsional" front right
    F_rbtfr = B_e_rbtfr * B_u_rbtfr * cRollBarTors;
    
    % Force at attach point anti roll bar "lateral" front left
    F_rblfl = B_e_rblfl * B_u_rblfl * cRollBarLat;
       
    % Force at attach point anti roll bar "lateral" front right
    F_rblfr = B_e_rblfr * B_u_rblfr * cRollBarLat;
    
    % Force at attach point anti roll bar front left
    F_rbfl = B_e_rbfl * (B_u_rbfl-B_u_rbfr) * cRollBarLin;
    
    % Force at attach point anti roll bar front right
    F_rbfr = B_e_rbfr * (B_u_rbfr-B_u_rbfl) * cRollBarLin;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% sum force and torque
    B_F_x = sum([F_sdfl(1) F_sdfr(1) F_sdrl(1) F_sdrr(1) F_sarl(1) F_sarr(1) F_rbtfl(1) F_rbtfr(1) F_rblfl(1) F_rblfr(1) F_rbfl(1) F_rbfr(1)]); 
    B_F_y = sum([F_sdfl(2) F_sdfr(2) F_sdrl(2) F_sdrr(2) F_sarl(2) F_sarr(2) F_rbtfl(2) F_rbtfr(2) F_rblfl(2) F_rblfr(2) F_rbfl(2) F_rbfr(2)]);
    B_F_z = sum([F_sdfl(3) F_sdfr(3) F_sdrl(3) F_sdrr(3) F_sarl(3) F_sarr(3) F_rbtfl(3) F_rbtfr(3) F_rblfl(3) F_rblfr(3) F_rbfl(3) F_rbfr(3)]);

    B_M_sdfl = cross(B_A_C * C_r0_CCsdfl, F_sdfl);
    B_M_sdfr = cross(B_A_C * C_r0_CCsdfr, F_sdfr);
    B_M_sdrl = cross(B_A_C * C_r0_CCsdrl, F_sdrl);
    B_M_sdrr = cross(B_A_C * C_r0_CCsdrr, F_sdrr);
    
    B_M_sarl = cross(B_A_C * C_r0_CCsarl, F_sarl) .* [1; 1; 0];
    B_M_sarr = cross(B_A_C * C_r0_CCsarr, F_sarr) .* [1; 1; 0];
    
    B_M_rbtfl = cross(B_A_C * C_r0_CCrbtfl, F_rbtfl) .* [1; 1; 0];
    B_M_rbtfr = cross(B_A_C * C_r0_CCrbtfr, F_rbtfr) .* [1; 1; 0];
    
    B_M_rblfl = cross(B_A_C * C_r0_CCrblfl, F_rblfl);
    B_M_rblfr = cross(B_A_C * C_r0_CCrblfr, F_rblfr);
    
    B_M_rbfl = cross(B_A_C * C_r0_CCrblfl, F_rbfl);
    B_M_rbfr = cross(B_A_C * C_r0_CCrblfr, F_rbfr);
    
    B_M_x = sum([B_M_sdfl(1) B_M_sdfr(1) B_M_sdrl(1) B_M_sdrr(1) B_M_sarl(1) B_M_sarr(1) B_M_rbtfl(1) B_M_rbtfr(1) B_M_rblfl(1) B_M_rblfr(1) B_M_rbfl(1) B_M_rbfr(1)]);
    B_M_y = sum([B_M_sdfl(2) B_M_sdfr(2) B_M_sdrl(2) B_M_sdrr(2) B_M_sarl(2) B_M_sarr(2) B_M_rbtfl(2) B_M_rbtfr(2) B_M_rblfl(2) B_M_rblfr(2) B_M_rbfl(2) B_M_rbfr(2)]);
    B_M_z = sum([B_M_sdfl(3) B_M_sdfr(3) B_M_sdrl(3) B_M_sdrr(3) B_M_sarl(3) B_M_sarr(3) B_M_rbtfl(3) B_M_rbtfr(3) B_M_rblfl(3) B_M_rblfr(3) B_M_rbfl(3) B_M_rbfr(3)]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% external stimulation due acceleraion, transform acceleration from COG Cabin to xy-level of Chassis
    B_uM = cross([0; 0; B_r_BC(3)], (mCabin * B_A_C * [-C_AccX_IMU; -C_AccY_IMU; -C_AccZ_IMU]));

    B_uF = mCabin * B_A_C * [-C_AccX_IMU ; -C_AccY_IMU ; -C_AccZ_IMU + g]; 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% principle of impulse and momentum 
    % F = m*a;
    % M = J*omega_p

    roll_p     = 1*roll_p;
    pitch_p    = 1*pitch_p;
    yaw_p      = 1*yaw_p*0;
    roll_pp    = 1/C_Jxx * (B_M_x + B_uM(1));
    pitch_pp   = 1/C_Jyy * (B_M_y + B_uM(2));
    yaw_pp     = 1/C_Jzz * (B_M_z + B_uM(3))*0;
    B_dx_p     = 1*B_dx_p*0;
    B_dy_p     = 1*B_dy_p*0;
    B_dz_p     = 1*B_dz_p;
    B_dx_pp    = 1/mCabin * (B_F_x + B_uF(1))*0;
    B_dy_pp    = 1/mCabin * (B_F_y + B_uF(2))*0;
    B_dz_pp    = 1/mCabin * (B_F_z + B_uF(3));

    B_xp = [roll_p pitch_p yaw_p roll_pp pitch_pp yaw_pp B_dx_p B_dy_p B_dz_p B_dx_pp B_dy_pp B_dz_pp];

    B_x  = B_x_old + B_xp * dT;

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function F = getInterpolatedForce(LUT, dx) 

    dx_LUT = LUT(:,1);
    y_LUT  = LUT(:,2);
 
    dx_interpol = linspace(min(dx_LUT),max(dx_LUT),1000);
             
    F_interpolatet = interp1(dx_LUT,y_LUT,dx_interpol);
    
    %find nearest
    [~,index] = (min(abs(dx_interpol - dx)));
    
    F = F_interpolatet(index);
    
end




