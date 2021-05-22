close all;
clear all;
clc;

N_MC               = 20;

%BF algorithm parameters ...
BF_params.p        = 26;        %Dimension of the search space (26)
BF_params.S        = 10;        %Total number of bacteria in the population (20)
BF_params.N_c      = 10;        %The number of chemotactic steps  (10)
BF_params.N_s      = 10;        %The swimming length (10)
BF_params.N_re     = 5;         %The number of reproduction steps (5)
BF_params.N_ed     = 5;         %The number of elimination-dispersal events (5)
BF_params.P_ed     = 0.5;       %Elimination-dispersal probability
BF_params.Shffle_1 = 3;
BF_params.A        = [ones(BF_params.Shffle_1,1); zeros(BF_params.p- BF_params.Shffle_1,1)];
BF_params.nearest_PV = 3;

%Network parameters ...
N_data.N_opt_my         = 5;		% Number of best PV-phase solutions selected from my POWER-BALANCE analysis	(3)
N_data.Unbalance_limit	= 0.3;      % Unbalance Limit (0.3)
N_data.PF_SCALE			= 1;        % Panelty Factor Scale (20)
N_data.OF_SCALE			= 5;        % Panelty Factor Scale (1)
N_data.pv_scale         = 0.7;		% PV-Scale (0.7)
N_data.load_scale       = 1.0;		% Load-scale (1.0)
N_data.Sing_Phase_Load_Power   = xlsread('Data.xlsx', 'Sing_Phase_Load_Power');
N_data.powerfactor             = xlsread('Data.xlsx', 'powerfactor');
N_data.pv_details              = xlsread('Data.xlsx', 'pv_details');

% Optimum solutions for each feeder sections...
N_data.A = Optimimum_PV_Location(N_data,1,14);
N_data.B = Optimimum_PV_Location(N_data,15,24);
N_data.C = Optimimum_PV_Location(N_data,25,30);
N_data.D = Optimimum_PV_Location(N_data,31,38);
N_data.E = Optimimum_PV_Location(N_data,39,47);
N_data.F = Optimimum_PV_Location(N_data,48,56);
N_data.G = Optimimum_PV_Location(N_data,57,62);

for mc = 1:N_MC
    display(strcat('MC = ',num2str(mc)));
    for i=1:BF_params.S
        %Position_my(i,:)  = [N_data.A(randi(N_data.N_opt_my),:), N_data.B(randi(N_data.N_opt_my),:), N_data.C(randi(N_data.N_opt_my),:), N_data.D(randi(N_data.N_opt_my),:), N_data.E(randi(N_data.N_opt_my),:), N_data.F(randi(N_data.N_opt_my),:), N_data.G(randi(N_data.N_opt_my),:)];
        Position_def(i,:) =  randi(3, [1, BF_params.p]);
    end
    Best_our = Run_BF_my(BF_params, Position_def, N_data);
    BFCost_our(mc,:) = Best_our.Cost';
    
    Best_def = Run_BF(BF_params, Position_def, N_data);
    BFCost_def(mc,:) = Best_def.Cost';
end

figure(1);
hold on;
grid on;
xlabel('# of itterations');
ylabel('Best cost');
for i=1:N_MC
    plot(mean(BFCost_our),'r.-', 'Linewidth', 2.0,'MarkerSize',5);
    plot(mean(BFCost_def),'b.-', 'Linewidth', 2.0,'MarkerSize',5);
end
legend('D-Chemotaxis','Classical Chemotaxis');
%title('The effect of D-chemotaxis');
