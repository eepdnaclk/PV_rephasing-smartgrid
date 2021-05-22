% Author: Chaminda Bandara
% Modified MSFLA Algorithm
% Date: 19th-January-2020

clc;
clear;
close all;

[N_data, fla_params] = Load_Parameters();                   % Load parameters
CostFunction = @(x,N_data) Lotus_Grove_Cost_Fn(x,N_data);	% OBJECTIVE Fun: x-Position

for MC = 1:fla_params.N_MC
	% Empty Individual Template
	empty_individual.Position 	= [];
	empty_individual.Cost 		= [];

	% Initialize Population Array
	pop = repmat(empty_individual, fla_params.nPop, 1);

	% Initialize Population Members
	for i=1:fla_params.nPop
        %% Assign Best possible values for the phase where unbalance factor is highest
        % Batcvh job 12
        if i==1
            %pop(i).Position = randi(VarMax,VarSize);
            pop(i).Position     = [N_data.A(1,:), N_data.B(1,:), N_data.C(1,:), N_data.D(1,:), N_data.E(1,:), N_data.F(1,:), N_data.G(1,:)];
            [pop(i).Cost, UF] 	= CostFunction(pop(i).Position,N_data);
        else
            [~, Max_Loc]    = max(UF);
            pop(i).Position = pop(i-1).Position;
            if Max_Loc>=1 && Max_Loc<=14
                pop(i).Position(N_data.pv_details(:,1)'>=1 & N_data.pv_details(:,1)'<=14) = N_data.A(randi(fla_params.N_opt_my,1),:);
            elseif Max_Loc>=15 && Max_Loc<=24
                pop(i).Position(N_data.pv_details(:,1)'>=15 & N_data.pv_details(:,1)'<=24) = N_data.B(randi(fla_params.N_opt_my,1),:);
            elseif Max_Loc>=25 && Max_Loc<=30
                pop(i).Position(N_data.pv_details(:,1)'>=25 & N_data.pv_details(:,1)'<=30) = N_data.C(randi(fla_params.N_opt_my,1),:);
            elseif Max_Loc>=31 && Max_Loc<=38
                pop(i).Position(N_data.pv_details(:,1)'>=31 & N_data.pv_details(:,1)'<=38) = N_data.D(randi(fla_params.N_opt_my,1),:);
            elseif Max_Loc>=39 && Max_Loc<=47
                pop(i).Position(N_data.pv_details(:,1)'>=39 & N_data.pv_details(:,1)'<=47) = N_data.E(randi(fla_params.N_opt_my,1),:);
            elseif Max_Loc>=48 && Max_Loc<=56
                pop(i).Position(N_data.pv_details(:,1)'>=48 & N_data.pv_details(:,1)'<=56) = N_data.F(randi(fla_params.N_opt_my,1),:);
            else
                pop(i).Position(N_data.pv_details(:,1)'>=57 & N_data.pv_details(:,1)'<=62) = N_data.G(randi(fla_params.N_opt_my,1),:);
            end     
            mix         = [ones(1,fla_params.Mixing_ones), zeros(1,length(pop(i).Position)-fla_params.Mixing_ones)];
            MIX_rand 	= logical(mix(randperm(length(mix))));
            MIX_rand_c  = ~MIX_rand;
            
            pop(i).Position = MIX_rand.*pop(i).Position + MIX_rand_c.*randi(fla_params.VarMax,fla_params.VarSize);
            [pop(i).Cost, UF] 	= CostFunction(pop(i).Position,N_data);
        end
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
		
        Result_MC_our(MC).Cost(it) = BestSol.Cost;
        Result_MC_our(MC).Position(it,:) = BestSol.Position;
        
		% Store Best Cost Ever Found
		% BestCosts(it) = BestSol.Cost;
		
		% Store Best Position Ever Found
		% BestPos(it,:) = BestSol.Position;
		
		% Show Iteration Information
		disp(['MC =', num2str(MC), ' |Iteration ' num2str(it) ': Best Cost = ' num2str(BestSol.Cost) ': Best Pos = ' num2str(BestSol.Position)]);
	end
end
save('Result_MC_our.mat','Result_MC_our');