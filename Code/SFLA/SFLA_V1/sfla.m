% Author: Chaminda Bandara
% Modified MSFLA Algorithm
% Date: 19th-January-2020

clc;
clear;
close all;

%% Extract PV Details
N_data.Sing_Phase_Load_Power   = xlsread('Data.xlsx', 'Sing_Phase_Load_Power');
N_data.powerfactor             = xlsread('Data.xlsx', 'powerfactor');
N_data.pv_details              = xlsread('Data.xlsx', 'pv_details');

%% Problem Definition

% Objective Function
CostFunction = @(x,N_data) Sphere(x,N_data);

nVar    = 26;               % Number of Unknown Variables
VarSize = [1 nVar];         % Unknown Variables Matrix Size

VarMin = 1;                 % Lower Bound of Unknown Variables
VarMax = 3;                 % Upper Bound of Unknown Variables


%% SFLA Parameters

MaxIt = 1000;        % Maximum Number of Iterations

nPopMemeplex = 30;                          % Memeplex Size
nPopMemeplex = max(nPopMemeplex, nVar+1);   % Nelder-Mead Standard

nMemeplex = 5;                  % Number of Memeplexes
nPop = nMemeplex*nPopMemeplex;	% Population Size

I = reshape(1:nPop, nMemeplex, []);

% FLA Parameters
fla_params.q = max(round(0.3*nPopMemeplex),2);   % Number of Parents
fla_params.alpha = 3;   % Number of Offsprings
fla_params.beta = 5;    % Maximum Number of Iterations
fla_params.sigma = 2;   % Step Size
fla_params.CostFunction = CostFunction;
fla_params.VarMin = VarMin;
fla_params.VarMax = VarMax;

%% Initialization

% Empty Individual Template
empty_individual.Position = [];
empty_individual.Cost = [];

% Initialize Population Array
pop = repmat(empty_individual, nPop, 1);

% Initialize Population Members
for i=1:nPop
    %pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
    pop(i).Position = randi(VarMax,VarSize);
    pop(i).Cost = CostFunction(pop(i).Position,N_data);
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
    
    % Store Best Cost Ever Found
    BestCosts(it) = BestSol.Cost;
	
	% Store Best Position Ever Found
    BestPos(it,:) = BestSol.Position;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCosts(it)) ': Best Pos = ' num2str(BestPos(it,:))]);
    
end

%% Results

figure;
%plot(BestCosts, 'LineWidth', 2);
semilogy(BestCosts, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;
