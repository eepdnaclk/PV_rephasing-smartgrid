% Author: Chaminda Bandara
% Modified MSFLA Algorithm
% Date: 19th-January-2020

function z = Sphere(pvphase,N_data)

    %z = sum(x.^2);
    [ ~, Unbalance_factor] = Load_Flow_LG(pvphase,N_data);
    
    Unbalance_limit = 0.5;
    
    % IEEE Standard unbalance factor
	Objective_func = mean(Unbalance_factor);

	% Panalty
	%1) Deviation from Unbalance limit
	PF1 = sum(Unbalance_factor((Unbalance_factor - Unbalance_limit) > 0) - Unbalance_limit);

	% Calculation of Fitness function
	z =  Objective_func + 1*(PF1);

end
