% Author: Chaminda Bandara
% Modified MSFLA Algorithm
% Date: 19th-January-2020

%Changes
%PV-scale = 0.7;

clc;
clear;
close all;

% Number of Monte-Carllo simulation
N_MC                        = 35;

% Network Parameters
N_data.Unbalance_limit		= 0.3;  % Unbalance Limit
N_data.PF_SCALE				= 20;   % Panelty Factor Scale
N_data.OF_SCALE				= 0;    % Panelty Factor Scale
N_data.pv_scale             = 1.0;
N_data.load_scale           = 1.3;

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


for MC=1:N_MC
	%% Initialization
	% Empty Individual Template
	empty_individual.Position 	= [];
	empty_individual.Cost 		= [];

	% Initialize Population Array
	pop = repmat(empty_individual, nPop, 1);

	% Initialize Population Members
	for i=1:nPop
		pop(i).Position = randi(VarMax,VarSize);
		pop(i).Cost 	= CostFunction(pop(i).Position,N_data);
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
    'MarkerEdgeColor','red','MarkerFaceColor','red');
xlabel('Iteration');
ylabel('Best Cost');
grid on;
xlim([1 MaxIt+0.5]);
title('Mean Best Cost - Shuffled Frog Leaping Algorithm - Default Algorithm');