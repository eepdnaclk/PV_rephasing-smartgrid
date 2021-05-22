% Author: Chaminda Bandara
% Modified MSFLA Algorithm
% Date: 19th-January-2020
clc;
clear;
close all;

[N_data, fla_params] = Load_Parameters();
% Objective Function
CostFunction = @(x,N_data) Lotus_Grove_Cost_Fn(x,N_data);	% x Denote the population (PV COMBINATION)

for MC=1:fla_params.N_MC
	% Empty Individual Template
	empty_individual.Position 	= [];
	empty_individual.Cost 		= [];

	% Initialize Population Array
	pop = repmat(empty_individual, fla_params.nPop, 1);

	% Initialize Population Members
	for i=1:fla_params.nPop
		pop(i).Position = randi(fla_params.VarMax,fla_params.VarSize);
		pop(i).Cost 	= CostFunction(pop(i).Position,N_data);
	end

	% Sort Population
	pop = SortPopulation(pop);

	% Update Best Solution Ever Found
	BestSol = pop(1);

	% Initialize Best Costs Record Array
	BestCosts = nan(fla_params.MaxIt, 1);

	% Initialize Best Pos Record Array
	BestPos = nan(fla_params.MaxIt, fla_params.nVar);

	%% SFLA Main Loop
	for it = 1:fla_params.MaxIt
		
		fla_params.BestSol = BestSol;

		% Initialize Memeplexes Array
		Memeplex = cell(fla_params.nMemeplex, 1);
		
		% Form Memeplexes and Run FLA
		for j = 1:fla_params.nMemeplex
			% Memeplex Formation
			Memeplex{j} = pop(fla_params.I(j,:));
			
			% Run FLA
			Memeplex{j} = RunFLA(Memeplex{j}, fla_params, N_data);
			
			% Insert Updated Memeplex into Population
			pop(fla_params.I(j,:)) = Memeplex{j};
		end
		
		% Sort Population
		pop = SortPopulation(pop);
		
		% Update Best Solution Ever Found
		BestSol = pop(1);
		
        Result_MC_def(MC).Cost(it) = BestSol.Cost;
        Result_MC_def(MC).Position(it,:) = BestSol.Position;
        
		% Store Best Cost Ever Found
		% BestCosts(it) = BestSol.Cost;
		
		% Store Best Position Ever Found
		% BestPos(it,:) = BestSol.Position;
		
		% Show Iteration Information
		disp(['MC =', num2str(MC), ' |Iteration ' num2str(it) ': Best Cost = ' num2str(BestSol.Cost) ': Best Pos = ' num2str(BestSol.Position)]);
    end
end
save('Result_MC_def.mat','Result_MC_def');