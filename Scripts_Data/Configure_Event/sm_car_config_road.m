function sm_car_config_road(modelname,scenename)
%% Description: 
% This function sets up a suitable road type base on the chosen scene. Some
% of the road type can support variable height. The road type with variable
% height use CRG files 

% Find variant subsystems for inputs
f=Simulink.FindOptions('LookUnderMasks','all');
mu_scaling_h=Simulink.findBlocks(modelname,'Name','Mu Scaling by Position',f);

f=Simulink.FindOptions('LookUnderMasks','all','regexp',1);
scene_config_h=Simulink.findBlocks(modelname,'SceneDesc','.*',f);

if(~isempty(scene_config_h))
    set_param(scene_config_h,'SceneDesc','Double lane change');
end

% Set vehicle data to have flat road as default. This will be changed if
% the user opts for a CRG road
Vehicle = evalin('base','Vehicle');
roadFile  = 'which(''TNO_FlatRoad.rdf'')';
assignin('base','Vehicle',Vehicle);

trailer_var = get_param([modelname '/Vehicle/Trailer/Trailer'],'Vehicle');
Trailer = evalin('base',trailer_var);

% Find fieldnames for tires
chassis_fnames   = fieldnames(Vehicle.Chassis);
fname_inds_tire  = startsWith(chassis_fnames,'Tire');
tireFields       = chassis_fnames(fname_inds_tire);
tireFields       = sort(tireFields); % Order important for copying Body sAxle values

% Loop over tire field names (by axle)
for axle_i = 1:length(tireFields)
    tireField = tireFields{axle_i};
    % Get tire class and settings
    if(~strcmp(Vehicle.Chassis.(tireField).class.Value,'Tire2x'))
        % For Road Surface
        tirClass{axle_i} = Vehicle.Chassis.(tireField).class.Value; %#ok<*AGROW>
        tir_diag_str{axle_i} = ['Vehicle.Chassis.' tireField  '.class.Value'];
        % For Testrig Post
        tirInst{axle_i}  = Vehicle.Chassis.(tireField).Instance;
        tirBody{axle_i}  = Vehicle.Chassis.(tireField).TireBody;
    else
        % For Road Surface - Assumes TireInner and TireOuter are the same
        tirClass{axle_i} = Vehicle.Chassis.(tireField).TireInner.class.Value;
        tir_diag_str{axle_i} = ['Vehicle.Chassis.' tireField  '.TireInner.class.Value'];
        % For Testrig Post
        tirInst{axle_i}      = Vehicle.Chassis.(tireField).TireInner.Instance;
        tirBody_Inn{axle_i}  = Vehicle.Chassis.(tireField).TireInner.TireBody;
        tirBody_Out{axle_i}  = Vehicle.Chassis.(tireField).TireOuter.TireBody;
    end
end

% Construct diagnostic string for Vehicle tires
tire_diag_str_fmt = [];
for axle_i = 1:length(tireFields)
    if(axle_i>1)
        tire_diag_str_fmt = [tire_diag_str_fmt '\n'];
    end
    tire_diag_str_fmt = [tire_diag_str_fmt '** ''' tir_diag_str{axle_i} ''' is ''' tirClass{axle_i} ''];
end

% Get Trailer tire class and settings
% For Road Surface
trailer_type = sm_car_vehcfg_getTrailerType(modelname);
if(strcmpi(trailer_type,'none'))
    % For Road Surface
    tirClassTr = 'None';
    tireFieldsTr = '';
else
    % Find fieldnames for tires
    chassis_fnamesTr = fieldnames(Trailer.Chassis);
    fname_inds_tireTr = startsWith(chassis_fnamesTr,'Tire');
    tireFieldsTr = chassis_fnamesTr(fname_inds_tireTr);
    tireFieldsTr = sort(tireFieldsTr); % Order important for copying Body sAxle values

    for axle_i = 1:length(tireFieldsTr)
        tireField = tireFieldsTr{axle_i};
        % Get tire class and settings
        if(~strcmp(Trailer.Chassis.(tireField).class.Value,'Tire2x'))
            % For Road Surface
            tirClassTr{axle_i} = Trailer.Chassis.(tireField).class.Value;
            tir_diag_strTr{axle_i} = ['Trailer.Chassis.' tireField  '.class.Value'];
        else
            % For Road Surface - Assumes TireInner and TireOuter are the same
            tirClassTr{axle_i} = Trailer.Chassis.(tireField).TireInner.class.Value;
            tir_diag_strTr{axle_i} = ['Vehicle.Chassis.' tireField  '.TireInner.class.Value'];
        end
    end
end

% Construct diagnostic string for Vehicle tires
tireTr_diag_str_fmt = [];
if(~strcmpi(tirClassTr,'none'))
    for axleTr_i = 1:length(tireFieldsTr)
        if(axleTr_i>1)
            tireTr_diag_str_fmt = [tireTr_diag_str_fmt '\n'];
        end
        tireTr_diag_str_fmt = [tireTr_diag_str_fmt '** ''' tir_diag_strTr{axleTr_i} ''' is ''' tirClassTr{axleTr_i} ''];
    end
else
    tireTr_diag_str_fmt = '';
end

% Set ground to have high friction everywhere
set_param(mu_scaling_h,'muFL_in','1','muFR_in','1','muRL_in','1','muRR_in','1')

% Specific checks for combinations: Non-flat CRG files
checkNonFlatCRG = sum([contains(tirClass,'MFEval') contains(tirClassTr,'MFEval')]);
messgNonFlatCRG1 = 'Configure model to use Delft Tire, MF-Swift, or Simscape  for this maneuver.';
messgNonFlatCRG2 = '--> All values for active components should be ''Delft'', ''MFSwift'', or ''Simscape''';

% Switch based on requested road surface
switch lower(scenename)
    case 'plane grid'
        % No special commands

    case 'crg custom'
        if(checkNonFlatCRG)
            error_str = sprintf([messgNonFlatCRG1 '\n' ...
                tire_diag_str_fmt '\n'...
                tireTr_diag_str_fmt '\n'...
                messgNonFlatCRG2]);
            errordlg(error_str,'Wrong Tire Software')
        end

        % Select CRG file
        roadFile = 'which(''CRG_Custom.crg'')';

        set_param(modelname,'StopTime','200')

    case 'crg rough road'
        if(checkNonFlatCRG)
            error_str = sprintf([messgNonFlatCRG1 '\n' ...
                tire_diag_str_fmt '\n'...
                tireTr_diag_str_fmt '\n'...
                messgNonFlatCRG2]);
            errordlg(error_str,'Wrong Tire Software')
        end

        % Select CRG file for slope
        roadFile = 'which(''CRG_Rough_Road.crg'')';

    case 'double lane change'
        % No special commands
end
set_param([modelname '/World'],'popup_scene',scenename);

% Set road file for all tires
% Vehicle
for axle_i = 1:length(tireFields)
    tireField = tireFields{axle_i};

    if(~strcmp(Vehicle.Chassis.(tireField).class.Value,'Tire2x'))
        Vehicle.Chassis.(tireField).roadFile.Value = roadFile;
    else
        % Assumes TireInner and TireOuter are the same
        Vehicle.Chassis.(tireField).TireInner.roadFile.Value = roadFile;
        Vehicle.Chassis.(tireField).TireOuter.roadFile.Value = roadFile;
    end
end

% Trailer
for axleTr_i = 1:length(tireFieldsTr)
    tireField = tireFields{axleTr_i};
    if(~strcmp(Trailer.Chassis.(tireField).class.Value,'Tire2x'))
        Trailer.Chassis.(tireField).roadFile.Value = roadFile;
    else
        % Assumes TireInner and TireOuter are the same
        Trailer.Chassis.(tireField).TireInner.roadFile.Value = roadFile;
        Trailer.Chassis.(tireField).TireOuter.roadFile.Value = roadFile;
    end
end


%% Assign results to workspace
assignin('base','Vehicle',Vehicle);
assignin('base',trailer_var,Trailer);


