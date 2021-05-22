close all;
clear all;
clc;

N_MC               = 5;

%BF algorithm parameters ...
BF_params.p        = 26;        %Dimension of the search space (26)
BF_params.S        = 10;        %Total number of bacteria in the population (20)
BF_params.N_c      = 10;        %The number of chemotactic steps  (10)
BF_params.N_s      = 10;        %The swimming length (10)
BF_params.N_re     = 5;         %The number of reproduction steps (5)
BF_params.N_ed     = 5;         %The number of elimination-dispersal events (5)
BF_params.P_ed     = 0.5;       %Elimination-dispersal probability
BF_params.Shffle_1 = 5;
BF_params.A        = [ones(BF_params.Shffle_1,1); zeros(BF_params.p- BF_params.Shffle_1,1)];
BF_params.nearest_PV = 3;

%Network parameters ...
N_data.N_opt_my         = 3;		% Number of best PV-phase solutions selected from my POWER-BALANCE analysis	(3)
N_data.Unbalance_limit	= 0.3;      % Unbalance Limit (0.3)
N_data.PF_SCALE			= 1;        % Panelty Factor Scale (20)
N_data.OF_SCALE			= 5;        % Panelty Factor Scale (1)
N_data.pv_scale         = 0.7;		% PV-Scale (0.7)
N_data.load_scale       = 1.0;		% Load-scale (1.0)
N_data.Sing_Phase_Load_Power   = xlsread('Data.xlsx', 'Sing_Phase_Load_Power');
N_data.powerfactor             = xlsread('Data.xlsx', 'powerfactor');
N_data.pv_details              = xlsread('Data.xlsx', 'pv_details');


%% Observe the effect of initialization
J_last=10000;
for mc = 1:N_MC
    for it = 1:250
        tic
        fprintf('MC=%d, Itteration = %d\n',mc,it);
        for i=1:BF_params.S
           Position_def =  randi(3, [1, BF_params.p]);
           [J,Unbalance_factor]  = Lotus_Grove_Cost_Fn(Position_def,N_data);
           if J<J_last
               J_last=J;
           end
        end
        Jbest(it,mc) = J_last;
        toc
    end
    Jbest(1,mc) = Jbest(2,mc);
    J_last=10000;
end

load('Heuristic.mat')
figure(1);
hold on;
plot(mean(Heuristic'));