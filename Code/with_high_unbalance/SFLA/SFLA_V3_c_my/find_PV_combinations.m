function [ opt_pv_combs, min_error ] = find_PV_combinations( All_pv_cap, required_pv  )

 N_PV = length(All_pv_cap);
 PV_combinations = unique(combntns([1.*ones(1,N_PV), 3.*ones(1,N_PV), 2.*ones(1,N_PV)],N_PV),'rows');
 
 [N1,~]=size(PV_combinations);
 N=1;
 for I=1:N1
    TEMP = unique(perms(PV_combinations(I,:)),'rows');
    [N2,~]=size(TEMP);
    for J=1:N2
        pv_phase(N,:) = TEMP(1,:);
        pv_at_each_phase = [sum(All_pv_cap(pv_phase(N,:)==1)), sum(All_pv_cap(pv_phase(N,:)==2)), sum(All_pv_cap(pv_phase(N,:)==3))];
        Error(N,1) = sum((required_pv-pv_at_each_phase).^2);
        N=N+1;
    end
 end
 [min_error,N_opt]=min(Error);
 opt_pv_combs = pv_phase(N_opt,:);
end

