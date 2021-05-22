% Author: Chaminda Bandara
% Modified MSFLA Algorithm
% Date: 19th-January-2020

function [z,Unbalance_factor]  = Lotus_Grove_Cost_Fn(pvphase,N_data)
    [ ~, Unbalance_factor] 	= Load_Flow_LG(pvphase,N_data);
    
    Unbalance_limit 		= N_data.Unbalance_limit;
    PF_SCALE				= N_data.PF_SCALE;
    OF_SCALE				= N_data.OF_SCALE;
	
    % IEEE Standard unbalance factor
	Objective_func 			= mean(Unbalance_factor);

	% Panalty
	%1) Deviation from Unbalance limit
	PF1 = sum(Unbalance_factor((Unbalance_factor - Unbalance_limit) > 0) - Unbalance_limit);

	% Calculation of Fitness function
	z = OF_SCALE*Objective_func + PF_SCALE*(PF1);
end