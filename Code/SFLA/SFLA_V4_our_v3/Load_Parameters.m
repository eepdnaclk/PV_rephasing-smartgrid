function [N_data, fla_params] = Load_Parameters()
fla_params.N_MC             = 100;		% Number of Monte-Carlo simulations (35)
fla_params.N_opt_my         = 3;		% Number of best PV-phase solutions selected from my POWER-BALANCE analysis	(3)
fla_params.Mixing_ones      = 22;		% Number of fixed positions from the solution received from POWER-BALANCE analysis

N_data.Unbalance_limit		= 0.3;      % Unbalance Limit (0.3)
N_data.PF_SCALE				= 20;       % Panelty Factor Scale (20)
N_data.OF_SCALE				= 1;        % Panelty Factor Scale (1)
N_data.pv_scale             = 0.7;		% PV-Scale (0.7)
N_data.load_scale           = 1.0;		% Load-scale (1.0)

fla_params.No_of_Ones		= 20;       % Default (24)

N_data.Sing_Phase_Load_Power   = xlsread('Data.xlsx', 'Sing_Phase_Load_Power');
N_data.powerfactor             = xlsread('Data.xlsx', 'powerfactor');
N_data.pv_details              = xlsread('Data.xlsx', 'pv_details');

% Objective Function
CostFunction = @(x,N_data) Lotus_Grove_Cost_Fn(x,N_data);	% x Denote the population (PV COMBINATION)

fla_params.nVar    = 26;    % Number of Unknown Variables
fla_params.VarSize = [1 fla_params.nVar]; % Unknown Variables Matrix Size

VarMin 	= 1;    % Lower Bound of Unknown Variables
VarMax 	= 3;    % Upper Bound of Unknown Variables

fla_params.MaxIt 			= 5;    % Maximum Number of Iterations (Default = 5)
fla_params.nPopMemeplex 	= 5;    % Memeplex Size (Default - 5)
% nPopMemeplex 	= max(nPopMemeplex, fla_params.nVar+1);   	% Nelder-Mead Standard
fla_params.nMemeplex 		= 5;    % Number of Memeplexes (Default -5)
fla_params.nPop 			= fla_params.nMemeplex*fla_params.nPopMemeplex;		% Population Size
fla_params.I 				= reshape(1:fla_params.nPop, fla_params.nMemeplex, []);

fla_params.q 		= max(round(0.3*fla_params.nPopMemeplex),2);    % Number of Parents
fla_params.alpha 	= 3;    % Number of Offsprings
fla_params.beta 	= 5;    % Maximum Number of Iterations
fla_params.sigma 	= 2;    % Step Size
fla_params.CostFunction 	= CostFunction;
fla_params.VarMin 	= VarMin;
fla_params.VarMax 	= VarMax;

% Optimum solutions for each feeder sections...
N_data.A = Optimimum_PV_Location(N_data,fla_params, 1,14);
N_data.B = Optimimum_PV_Location(N_data,fla_params, 15,24);
N_data.C = Optimimum_PV_Location(N_data,fla_params, 25,30);
N_data.D = Optimimum_PV_Location(N_data,fla_params, 31,38);
N_data.E = Optimimum_PV_Location(N_data,fla_params, 39,47);
N_data.F = Optimimum_PV_Location(N_data,fla_params, 48,56);
N_data.G = Optimimum_PV_Location(N_data,fla_params, 57,62);
clc;
end

