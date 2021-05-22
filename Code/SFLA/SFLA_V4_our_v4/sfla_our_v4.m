% Author: Chaminda Bandara
% Modified MSFLA Algorithm
% Date: 19th-January-2020

% Changes
% PV-scale = 0.7;

clc;
clear;
close all;

% Number of Monte-Carllo simulation
N_MC                        = 35;		% Number of Monte-Carlo simulations
N_data.N_opt_my             = 3;		% Number of best PV-phase solutions selected from my POWER-BALANCE analysis	
N_data.Mixing_ones          = 22;		% Number of fixed positions from the solution received from POWER-BALANCE analysis

% Network Parameters
N_data.Unbalance_limit		= 0.3;      % Unbalance Limit
N_data.PF_SCALE				= 20;       % Panelty Factor Scale
N_data.OF_SCALE				= 0;        % Panelty Factor Scale
N_data.pv_scale             = 0.7;		% PV-Scale
N_data.load_scale           = 1.0;		% Load-scale

% fla param
fla_params.No_of_Ones		= 24;

% Extract PV Details
N_data.Sing_Phase_Load_Power   = xlsread('Data.xlsx', 'Sing_Phase_Load_Power');
N_data.powerfactor             = xlsread('Data.xlsx', 'powerfactor');
N_data.pv_details              = xlsread('Data.xlsx', 'pv_details');

% Objective Function
CostFunction = @(x,N_data) Lotus_Grove_Cost_Fn(x,N_data);	% x Denote the population (PV COMBINATION)

% Parameters
nVar    = 26;               % Number of Unknown Variables
VarSize = [1 nVar];         % Unknown Variables Matrix Size

VarMin 	= 1;                 % Lower Bound of Unknown Variables
VarMax 	= 3;                 % Upper Bound of Unknown Variables

% SFLA Parameters
MaxIt 			= 15;        					% Maximum Number of Iterations
nPopMemeplex 	= 5;                          	% Memeplex Size
nPopMemeplex 	= max(nPopMemeplex, nVar+1);   	% Nelder-Mead Standard
nMemeplex 		= 5;                  			% Number of Memeplexes
nPop 			= nMemeplex*nPopMemeplex;		% Population Size
I 				= reshape(1:nPop, nMemeplex, []);

% FLA Parameters
fla_params.q 		= max(round(0.3*nPopMemeplex),2);   % Number of Parents
fla_params.alpha 	= 3;   								% Number of Offsprings
fla_params.beta 	= 5;    							% Maximum Number of Iterations
fla_params.sigma 	= 2;   								% Step Size
fla_params.CostFunction 	= CostFunction;
fla_params.VarMin 	= VarMin;
fla_params.VarMax 	= VarMax;

%Buckets...
N_data.A = Optimimum_PV_Location(N_data, 1,14); [~, n_NodesA] = size(N_data.A);
N_data.B = Optimimum_PV_Location(N_data, 15,24); [~, n_NodesB] = size(N_data.B);
N_data.C = Optimimum_PV_Location(N_data, 25,30); [~, n_NodesC] = size(N_data.C);
N_data.D = Optimimum_PV_Location(N_data, 31,38); [~, n_NodesD] = size(N_data.D);
N_data.E = Optimimum_PV_Location(N_data, 39,47); [~, n_NodesE] = size(N_data.E);
N_data.F = Optimimum_PV_Location(N_data, 48,56); [~, n_NodesF] = size(N_data.F);
N_data.G = Optimimum_PV_Location(N_data, 57,62); [~, n_NodesG] = size(N_data.G);
clc;

for MC=1:N_MC
	%% Initialization
	% Empty Individual Template
	empty_individual.Position 	= [];
	empty_individual.Cost 		= [];

	% Initialize Population Array
	pop = repmat(empty_individual, nPop, 1);

	% Initialize Population Members
	for i=1:nPop
        %% Assign Best possible values for the phase where unbalance factor is highest
        if i==1
            pop(i).Position     = [N_data.A(1,:), N_data.B(1,:), N_data.C(1,:), N_data.D(1,:), N_data.E(1,:), N_data.F(1,:), N_data.G(1,:)];
            [pop(i).Cost, UF] 	= CostFunction(pop(i).Position,N_data);
        else
            [~, Max_Loc]    = max(UF);
            pop(i).Position = pop(i-1).Position;
            if Max_Loc>=1 && Max_Loc<=14
                pop(i).Position(N_data.pv_details(:,1)'>=1 & N_data.pv_details(:,1)'<=14) = N_data.A(randi(N_data.N_opt_my,1),:);
            elseif Max_Loc>=15 && Max_Loc<=24
                pop(i).Position(N_data.pv_details(:,1)'>=15 & N_data.pv_details(:,1)'<=24) = N_data.B(randi(N_data.N_opt_my,1),:);
            elseif Max_Loc>=25 && Max_Loc<=30
                pop(i).Position(N_data.pv_details(:,1)'>=25 & N_data.pv_details(:,1)'<=30) = N_data.C(randi(N_data.N_opt_my,1),:);
            elseif Max_Loc>=31 && Max_Loc<=38
                pop(i).Position(N_data.pv_details(:,1)'>=31 & N_data.pv_details(:,1)'<=38) = N_data.D(randi(N_data.N_opt_my,1),:);
            elseif Max_Loc>=39 && Max_Loc<=47
                pop(i).Position(N_data.pv_details(:,1)'>=39 & N_data.pv_details(:,1)'<=47) = N_data.E(randi(N_data.N_opt_my,1),:);
            elseif Max_Loc>=48 && Max_Loc<=56
                pop(i).Position(N_data.pv_details(:,1)'>=48 & N_data.pv_details(:,1)'<=56) = N_data.F(randi(N_data.N_opt_my,1),:);
            else
                pop(i).Position(N_data.pv_details(:,1)'>=57 & N_data.pv_details(:,1)'<=62) = N_data.G(randi(N_data.N_opt_my,1),:);
            end
            [pop(i).Cost, UF] 	= CostFunction(pop(i).Position,N_data);
        end
	end

	% Sort Population
	pop = SortPopulation(pop);

	% Update Best Solution Ever Found
	BestSol = pop(1);

	% Initialize Best Costs Record Array
	BestCosts = nan(MaxIt, 1);

	% Initialize Best Pos Record Array
	BestPos = nan(MaxIt, nVar);

	%% SFLA Main Loop
	for it = 1:MaxIt
		
		fla_params.BestSol = BestSol;

		% Initialize Memeplexes Array
		Memeplex = cell(nMemeplex, 1);
		
		% Form Memeplexes and Run FLA
		for j = 1:nMemeplex
			% Memeplex Formation
			Memeplex{j} = pop(I(j,:));
			
			% Run FLA
			Memeplex{j} = RunFLA(Memeplex{j}, fla_params, N_data);
			
			% Insert Updated Memeplex into Population
			pop(I(j,:)) = Memeplex{j};
		end
		
		% Sort Population
		pop = SortPopulation(pop);
		
		% Update Best Solution Ever Found
		BestSol = pop(1);
		
        Result_MC(MC).Cost(it) = BestSol.Cost;
        Result_MC(MC).Position(it,:) = BestSol.Position;
        
		% Store Best Cost Ever Found
		% BestCosts(it) = BestSol.Cost;
		
		% Store Best Position Ever Found
		% BestPos(it,:) = BestSol.Position;
		
		% Show Iteration Information
		disp(['MC =', num2str(MC), ' |Iteration ' num2str(it) ': Best Cost = ' num2str(BestSol.Cost) ': Best Pos = ' num2str(BestSol.Position)]);
	end
end

%% Results
figure(1);
for i=1:N_MC
    hold on;
    Final_Result(i,:) = Result_MC(i).Cost;
    %semilogy(1:MaxIt,Result_MC(i).Cost,  'LineWidth', 2);
end
errorbar(1:MaxIt, mean(Final_Result), std(Final_Result),'-s','MarkerSize',10,...
    'MarkerEdgeColor','green','MarkerFaceColor','green');
xlabel('Iteration');
ylabel('Best Cost');
grid on;
xlim([1 MaxIt+0.5]);
title('Mean Best Cost - Shuffled Frog Leaping Algorithm - Our Method');