function [ Position ] = Optimimum_PV_Location( Opt_PV, N_data )
Start_Bus   = Opt_PV.Start_Bus;
Stop_Bus    = Opt_PV.Stop_Bus;
Position    = Opt_PV.Position;
pv_details  = N_data.pv_details;
load_details    = N_data.Sing_Phase_Load_Power;


% Select the PV region ...
selected_pv = pv_details(pv_details(:,1)>=Start_Bus & pv_details(:,1)<=Stop_Bus,:);
% Select the Load region ...
selected_load = load_details(load_details(:,1)>=Start_Bus & load_details(:,1)<=Stop_Bus,:);

% Calculate total capacity of PV connected to each phase ...
pv_T = [sum(selected_pv(selected_pv(:,3)==1,2)),sum(selected_pv(selected_pv(:,3)==2,2)),sum(selected_pv(selected_pv(:,3)==3,2))];
%Calculate total capacity of Loads connected to each phase
load_T = [sum(selected_load(:,2)),sum(selected_load(:,3)),sum(selected_load(:,4))];

PVs_1 = selected_pv(selected_pv(:,3)==1,2);
PVs_2 = selected_pv(selected_pv(:,3)==2,2);
PVs_3 = selected_pv(selected_pv(:,3)==3,2);
All_PVs = [PVs_1',PVs_2',PVs_3'];

avg_zero_level_power = mean(pv_T-load_T);
initial_power_level = -1.*load_T;
required_pv = avg_zero_level_power-initial_power_level;

[OPTIMUM_PV_COMB,~] = find_PV_combinations( All_PVs, required_pv);
Position(pv_details(:,1)>=Start_Bus & pv_details(:,1)<=Stop_Bus,end) = OPTIMUM_PV_COMB';
end

