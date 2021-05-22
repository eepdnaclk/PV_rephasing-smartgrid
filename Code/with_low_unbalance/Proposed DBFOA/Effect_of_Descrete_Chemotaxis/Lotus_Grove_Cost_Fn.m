% Author: Chaminda Bandara
% Modified MSFLA Algorithm
% Date: 19th-January-2020

function [z,Unbalance_factor]  = Lotus_Grove_Cost_Fn(pvphase,N_data)
    [ LF_V_abs, Unbalance_factor] 	= Load_Flow_LG(pvphase,N_data);
    
    Unbalance_limit 		= N_data.Unbalance_limit;
    PF_SCALE				= N_data.PF_SCALE;
    OF_SCALE				= N_data.OF_SCALE;
	
    % IEEE Standard unbalance factor
	Objective_func 			= mean(Unbalance_factor);

	% Panalties
	%1) Deviation from Unbalance limit
	PF1 = sum(Unbalance_factor((Unbalance_factor - Unbalance_limit) > 0));
    
    %2) Deviating from each phase - Voltage magniture between 0.96 and 1.04
    phase1_pu = LF_V_abs(:,1);
    phase2_pu = LF_V_abs(:,2);
    phase3_pu = LF_V_abs(:,3);    
    PF2 = sum(phase1_pu(phase1_pu<0.94 | phase1_pu>1.06)) + sum(phase2_pu(phase2_pu<0.94 | phase2_pu>1.06)) + sum(phase3_pu(phase3_pu<0.94 | phase3_pu>1.06));

    %3) Neutral Voltage
    PF3 = mean(LF_V_abs(:,4));
    
	% Calculation of Fitness function
	z = OF_SCALE*Objective_func + PF_SCALE*(PF1+PF2+PF3);
end