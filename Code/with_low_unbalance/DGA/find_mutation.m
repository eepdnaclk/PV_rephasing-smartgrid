function [ PV_phase ] = find_mutation( PV_phase,mutation_ratio)
[R_m, C_m] = size(PV_phase);
Total = C_m*R_m*mutation_ratio;

Mutation_count = round(Total);

R = randi(R_m, Mutation_count,1);
C = randi(C_m, Mutation_count,1);

for i=1:Mutation_count
    row = randi(2,1,1);
    switch PV_phase(R(i,1),C(i,1))
        case 1
            temp = [2,3];
            PV_phase(R(i,1),C(i,1)) = temp(1, row);
        case 2
            temp = [1,3];
            PV_phase(R(i,1),C(i,1)) = temp(1, row);
        otherwise
            temp = [1,2];
            PV_phase(R(i,1),C(i,1)) = temp(1, row);
    end
end
end

