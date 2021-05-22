function [best_pv_combs] = Optimimum_PV_Location(N_data, Start_Bus,Stop_Bus)
pv_details      = N_data.pv_details;
load_details    = N_data.Sing_Phase_Load_Power;

selected_pv     = pv_details(pv_details(:,1)>=Start_Bus & pv_details(:,1)<=Stop_Bus,1:3);
selected_load   = load_details(load_details(:,1)>=Start_Bus & load_details(:,1)<=Stop_Bus,1:4);

load_T          = [sum(selected_load(:,2)),sum(selected_load(:,3)),sum(selected_load(:,4))];

required_pv     = ((sum(selected_pv(:,2))-sum(load_T))/3).*ones(1,3)-load_T;

%[best_pv_combs,~] = find_PV_combinations( selected_pv(:,2)', required_pv);
 [N_PV,~] = size(selected_pv);
 PV_combinations = unique(combntns([1.*ones(1,N_PV), 3.*ones(1,N_PV), 2.*ones(1,N_PV)],N_PV),'rows');
 
 [N1,~]=size(PV_combinations);
 N=1;
 for I=1:N1
    TEMP    = unique(perms(PV_combinations(I,:)),'rows');
    [N2,~]  = size(TEMP);
    for J=1:N2
        pv_phase(N,:) = TEMP(J,:);
        pv_at_each_phase = [sum(selected_pv(pv_phase(N,:)==1),2), sum(selected_pv(pv_phase(N,:)==2),2), sum(selected_pv(pv_phase(N,:)==3),2)];
        Error(N,1) = sum((required_pv-pv_at_each_phase).^2);
        N=N+1;
    end
 end
 [~,location]=sort(Error);
 sorted_pv_combs = pv_phase(location,:);

 best_pv_combs = sorted_pv_combs(1:N_data.N_opt_my,:);
end

