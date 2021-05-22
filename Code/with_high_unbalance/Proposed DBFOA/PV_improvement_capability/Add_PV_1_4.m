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
BF_params.Shffle_1 = 3;
BF_params.A        = [ones(BF_params.Shffle_1,1); zeros(BF_params.p- BF_params.Shffle_1,1)];
BF_params.nearest_PV = 3;

%Network parameters ...
N_data.N_opt_my         = 5;		% Number of best PV-phase solutions selected from my POWER-BALANCE analysis	(3)
N_data.Unbalance_limit	= 0.3;      % Unbalance Limit (0.3)
N_data.PF_SCALE			= 1;        % Panelty Factor Scale (20)
N_data.OF_SCALE			= 5;        % Panelty Factor Scale (1)
N_data.Sing_Phase_Load_Power   = xlsread('Data.xlsx', 'Sing_Phase_Load_Power');
N_data.powerfactor             = xlsread('Data.xlsx', 'powerfactor');
N_data.pv_details              = xlsread('Data.xlsx', 'pv_details');

PV_p = [0,0,0,0,0,0,0,0.0200000000000000,0.340000000000000,0.580000000000000,0.790000000000000,0.930000000000000,1,0.990000000000000,0.870000000000000,0.710000000000000,0.510000000000000,0.310000000000000,0.0100000000000000,0,0,0,0,0,0];
Load = [0.1 0.1 0.1 0.1 0.4 0.3 0.4 0.4 0.3 0.3 0.5 0.6 0.7 0.6 0.5 0.6 0.7 0.8 0.9 1 1 0.6 0.5 0.2 0.1];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hour = 12;
N_data.pv_scale         = PV_p(hour+1);	
N_data.load_scale       = Load(hour+1);


%% Generate Results related to with PV re-phasing
for No_NewPV=1:1:4
    BF_params.p        = 26+No_NewPV;
    for MC=1:N_MC
        display(strcat('No of new PV = ',num2str(No_NewPV), ' MC =  ',num2str(MC)));
        N_data.pv_details = xlsread('Data.xlsx', 'pv_details');
        for i=1:No_NewPV
            N_data.pv_details(end+1,:) = [randi(61), mean(N_data.pv_details(:,2)), randi(3)];
        end
        
        Position_my = zeros(BF_params.S, BF_params.p);
        for i=1:BF_params.S
           Position_my(i,:) = randi(3,1,BF_params.p);
        end
        
        Best_our = Run_BF_my(BF_params, Position_my, N_data);
        
        %BFCost_cost(MC, No_NewPV)    = Best_our.Cost';
        BFCost_position    = Best_our.Position';
        
        [ V_re, VUF_re]   = Load_Flow_LG(BFCost_position, N_data);
        mean_VUF_re(MC, No_NewPV)  = mean(VUF_re);
        max_VUF_re(MC, No_NewPV)   = max(VUF_re);
        mean_V(MC, No_NewPV)       = mean(mean(V_re(:,1:3)));
        max_V(MC, No_NewPV)        = max(max(V_re(:,1:3)));
        min_V(MC, No_NewPV)        = min(min(V_re(:,1:3)));
    end
end

%% Generate results related to without PV Re-phasing
x = [1	2	3	4	5	6	7	8	9	10	11	12	14	16	18	20	22	24	26	28	30];
for No_NewPV=x
    BF_params.p        = 26+No_NewPV;
    for MC=1:N_MC
        display(strcat('No of new PV = ',num2str(No_NewPV), ' MC =  ',num2str(MC)));
        N_data.pv_details = xlsread('Data.xlsx', 'pv_details');
        for i=1:No_NewPV
            N_data.pv_details(end+1,:) = [randi(61), mean(N_data.pv_details(:,2)), randi(3)];
        end
        
        [ V_re, VUF_re]   = Load_Flow_LG(N_data.pv_details(:,3), N_data);
        mean_VUF_NoRephasing(MC, No_NewPV)  = mean(VUF_re);
        max_VUF_NoRephasing(MC, No_NewPV)   = max(VUF_re);
        mean_V_NoRephasing(MC, No_NewPV)       = mean(mean(V_re(:,1:3)));
        max_V_NoRephasing(MC, No_NewPV)        = max(max(V_re(:,1:3)));
        min_V_NoRephasing(MC, No_NewPV)        = min(min(V_re(:,1:3)));
    end
end