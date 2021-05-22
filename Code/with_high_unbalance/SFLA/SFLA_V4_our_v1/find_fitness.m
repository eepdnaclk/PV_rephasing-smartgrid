function [ Fitness_fun ] = find_fitness(Unbalance_factor, Penalty_F, Unbalance_limit)
% This function calculates the fitness value
% Author - Chaminda Bandara
% Date 14th - January - 2019

	% IEEE Standard unbalance factor
	Objective_func = mean(Unbalance_factor);

	% Panalty
	%1) Deviation from Unbalance limit
	PF1 = sum(Unbalance_factor((Unbalance_factor - Unbalance_limit) > 0) - Unbalance_limit);

	% Calculation of Fitness function
	Fitness_fun =  Objective_func + Penalty_F*(PF1);
end

