% Author: Chaminda Bandara
% Modified MSFLA Algorithm
% Date: 19th-January-2020

clc;
clear;
close all;

% Change these parameters
N_data.Unbalance_limit		= 0.5; % Unbalance Limit
N_data.PF_SCALE				= 10;   % Panelty Factor Scale
fla_params.No_of_Ones		= 25;

% Extract PV Details
N_data.Sing_Phase_Load_Power   = xlsread('Data.xlsx', 'Sing_Phase_Load_Power');
N_data.powerfactor             = xlsread('Data.xlsx', 'powerfactor');
N_data.pv_details              = xlsread('Data.xlsx', 'pv_details');
k
% Objective Function
CostFunction = @(x,N_data) Lotus_Grove_Cost_Fn(x,N_data);	% x Denote the population (PV COMBINATION)

% Parameters
nVar    = 26;               % Number of Unknown Variables
VarSize = [1 nVar];         % Unknown Variables Matrix Size

VarMin 	= 1;                 % Lower Bound of Unknown Variables
VarMax 	= 3;                 % Upper Bound of Unknown Variables

%% SFLA Parameters
MaxIt 			= 1500;        					% Maximum Number of Iterations
nPopMemeplex 	= 30;                          	% Memeplex Size
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
    
    % Store Best Cost Ever Found
    BestCosts(it) = BestSol.Cost;
	
	% Store Best Position Ever Found
    BestPos(it,:) = BestSol.Position;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCosts(it)) ': Best Pos = ' num2str(BestPos(it,:))]);
    
end

%% Results

figure(1);
%plot(BestCosts, 'LineWidth', 2);
semilogy(BestCosts, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;

[LF_V_abs_B, Unbalance_factor_B] = Load_Flow_LG(BestPos(end,:),N_data);
[LF_V_abs_D, Unbalance_factor_D] = Load_Flow_LG(N_data.pv_details(:,3),N_data);
figure(2); hold on; grid on; xlim([1 63])
plot(1:length(Unbalance_factor_D),Unbalance_factor_D,'ro-','Linewidth',1.5);
plot(1:length(Unbalance_factor_B),Unbalance_factor_B,'bo-','Linewidth',1.5);
xlabel('Node Number');
ylabel('Voltage Unbalance Factor');
title('Voltage Unbalance Factor for Best Case');

figure(3); hold on; grid on;
plot(LF_V_abs_B(:,1:3),'o-','Linewidth',1.5);
xlabel('Node Number');
ylabel('Voltage Unbalance Factor');
title('Voltage Unbalance Factor for Best Case');
legend('Phase - A','Phase - B','Phase - C');


%% GSP
close all;
[U, lambda] = GSP_on_Network(1);

a = zeros(63,1);
a(1) = 1;
a(2) = 1;
a(20) = 1;
%Localized Graph Signal Processing
LSV_Convolution_VUF_B = LSV_Convolution( 63, a, lambda, U, 10,0.1);
figure;
imagesc(LSV_Convolution_VUF_B');
colorbar;
xlim([1 63]);
ylim([1 63]);
xlabel('n');
ylabel('k');