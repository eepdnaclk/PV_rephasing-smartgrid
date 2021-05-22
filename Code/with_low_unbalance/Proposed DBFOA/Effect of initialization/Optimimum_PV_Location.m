function [best_pv_combs] = Optimimum_PV_Location(N_data, Start_Bus,Stop_Bus)
% Extract information from PV_details...
pvbus   = N_data.pv_details(:,1);
pvkw    = N_data.pv_scale.*N_data.pv_details(:,2);
pvphase = N_data.pv_details(:,3);

% Extract information from load_details ...
loadbus     = N_data.Sing_Phase_Load_Power(:,1);
load_p1     = N_data.load_scale.*N_data.Sing_Phase_Load_Power(:,2);
load_p2     = N_data.load_scale.*N_data.Sing_Phase_Load_Power(:,3);
load_p3     = N_data.load_scale.*N_data.Sing_Phase_Load_Power(:,4);

% Loads & PV pannels connected to selected section
% Load
Sel_load_123= [sum(load_p1(loadbus>=Start_Bus & loadbus<=Stop_Bus)), sum(load_p2(loadbus>=Start_Bus & loadbus<=Stop_Bus)), sum(load_p3(loadbus>=Start_Bus & loadbus<=Stop_Bus))];
% PV
Sel_PV_kw   = pvkw(pvbus>=Start_Bus & pvbus<=Stop_Bus);
Sel_pv_phase= pvphase(pvbus>=Start_Bus & pvbus<=Stop_Bus);
Sel_pv_123  = [sum(Sel_PV_kw(Sel_pv_phase==1)), sum(Sel_PV_kw(Sel_pv_phase==2)), sum(Sel_PV_kw(Sel_pv_phase==3))];
Total_PV    = sum(Sel_pv_123);

Total_load  = sum(Sel_load_123);

required_pv     = ones(1,3).*((Total_PV-Total_load)./3) +Sel_load_123;

%[best_pv_combs,~] = find_PV_combinations( selected_pv(:,2)', required_pv);
 N_PV = length(Sel_PV_kw);
 PV_combinations = unique(combntns([1.*ones(1,N_PV), 2.*ones(1,N_PV), 3.*ones(1,N_PV)],N_PV),'rows');
 
 [N_comb,~]=size(PV_combinations);
 N=1;
 for I=1:N_comb
    Ith_comb    = unique(perms(PV_combinations(I,:)),'rows');
    [N_each_iCOMB,~]      = size(Ith_comb);
    for J=1:N_each_iCOMB
        pv_phase(N,:) = Ith_comb(J,:);
        pv_kw_comb = [sum(Sel_PV_kw(pv_phase(N,:)'==1)),sum(Sel_PV_kw(pv_phase(N,:)'==2)),sum(Sel_PV_kw(pv_phase(N,:)'==3))];
        Error(N,1) = sum((required_pv-pv_kw_comb).^2);
        N=N+1;
    end
 end
 [~,Err_loc]=sort(Error);
 sorted_pv_combs = pv_phase(Err_loc,:);
 best_pv_combs = sorted_pv_combs(1:N_data.N_opt_my,:);
end

