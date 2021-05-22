function [ PV_change_loc ] = R_my( UB, N_data, BF_params )
n                   = BF_params.nearest_PV;
[~, Max_Loc]        = max(UB);

pv_details          = N_data.pv_details;
pv_loc              = pv_details(:,1);
Ab                  = abs(pv_loc-Max_Loc);
[~, Ab_index]       = sort(Ab);
result              = Ab(sort(Ab_index(1:n)));

PV_change_loc       = zeros(size(pv_loc));
for min_abs=1:n
    PV_change_loc   = PV_change_loc|(Ab==result(min_abs));
end
end

