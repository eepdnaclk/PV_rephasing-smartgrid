function [ regions ] = find_regions( Position, N_data )

[ LF_V_abs, UF] = Load_Flow_LG(pvphase,N_data);

Unbalance_fac(:,1) = transpose(1:length(UF));
Unbalance_fac(:,2) = UF;

Unbalance_fac(Unbalance_fac(:,2)>=N_data.Unbalance_limit,:)


end

