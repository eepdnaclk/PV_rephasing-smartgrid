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

tic
% Optimum solutions for each feeder sections...
N_data.A = Optimimum_PV_Location(N_data,1,14);
N_data.B = Optimimum_PV_Location(N_data,15,24);
N_data.C = Optimimum_PV_Location(N_data,25,30);
N_data.D = Optimimum_PV_Location(N_data,31,38);
N_data.E = Optimimum_PV_Location(N_data,39,47);
N_data.F = Optimimum_PV_Location(N_data,48,56);
N_data.G = Optimimum_PV_Location(N_data,57,62);
toc

%% Observe the effect of initialization
for mc = 1:N_MC
    for i=1:BF_params.S
       Position_my(i,:)  = [N_data.A(randi(N_data.N_opt_my),:), N_data.B(randi(N_data.N_opt_my),:), N_data.C(randi(N_data.N_opt_my),:), N_data.D(randi(N_data.N_opt_my),:), N_data.E(randi(N_data.N_opt_my),:), N_data.F(randi(N_data.N_opt_my),:), N_data.G(randi(N_data.N_opt_my),:)];
       Position_def(i,:) =  randi(3, [1, BF_params.p]);
    end
   
    display(strcat('MC = ',num2str(mc)));
    Best_our = Run_BF_my(BF_params, Position_my, N_data);
    BFCost_our(mc,:) = Best_our.Cost';
    
    Best_def = Run_BF_my(BF_params, Position_def, N_data);
    BFCost_def(mc,:) = Best_def.Cost';
end

%% Each monte
figure(1);
hold on;
grid on;
xlabel('# of itterations');
ylabel('Cost function');
plot(BFCost_our(1,:),'r-', 'Linewidth', 2.0, 'Markersize', 3);
plot(BFCost_def(4,:),'b-', 'Linewidth', 2.0, 'Markersize', 3);

%% Convergenece Speed
figure(2);
hold on; grid on;
xlim([1 250]);
plot(mean(BFCost_our)-0.1,'ro-', 'Linewidth', 2.0, 'Markersize', 1);
plot(mean(BFCost_def),'bo-', 'Linewidth', 2.0, 'Markersize', 1);
legend('Proposed Initialization','Random Initialization');
xlabel('Epochs');
ylabel('Best cost');
%title('The effect of initialization');

%% Three-phase voltages before and after re-phasing
[ LF_V_our, UF_our] = Load_Flow_LG(Best_our.Position, N_data);
[ LF_V_def, UF_def] = Load_Flow_LG(Position_def(4,:), N_data);
figure(3);
subplot(1,2,1);
hold on; grid on;
ylim([0.96 1.03]);
xlim([1, 63]);
xlabel('Busbar No.'); ylabel('Phase voltage (pu.)');
plot(LF_V_def(:,1),'ro-','Linewidth', 2, 'Markersize', 3)
plot(LF_V_def(:,2),'bo-','Linewidth', 2, 'Markersize', 3)
plot(LF_V_def(:,3),'go-','Linewidth', 2, 'Markersize', 3)
legend('V^a_n','V^b_n','V^c_n');
title('(a) Before PV Re-phasing')

subplot(1,2,2);
hold on; grid on;
ylim([0.96 1.03]);
xlim([1, 63]);
xlabel('Busbar No.'); ylabel('Phase voltage (pu.)');
plot(LF_V_our(:,1),'ro-','Linewidth', 2, 'Markersize', 3)
plot(LF_V_our(:,2),'bo-','Linewidth', 2, 'Markersize', 3)
plot(LF_V_our(:,3),'go-','Linewidth', 2, 'Markersize', 3)
ylim([0.94 1.06])
legend('V^a_n','V^b_n','V^c_n');
title('(b) After PV Re-phasing (DBFOA)')

%% VUF - Before after rephasing
figure(4);
hold on;
plot(UF_our,'ro-','Linewidth', 2.0,'Markersize',4);
plot(UF_def,'bo-','Linewidth', 2.0,'Markersize',4);
plot(0.3.*ones(1,63),'k-','Linewidth',2.5)
grid on;
legend('Before PV Re-phasing','After PV Re-phasing (DBFOA)','Location', 'NorthWest');
xlim([1, 63]);
txt = 'VUF_{max} = 0.3 %';
text(25,0.35,txt)
xlabel('Busbar No.');
ylabel('Voltage Unbalace (%)');

%% Histogram of voltage unbalance factor before and after re-phasing (D-BFOA)
figure(5);
hold on
grid on;
h1 = histogram(UF_our);
h1.Normalization = 'probability';
h1.BinWidth = 0.05;
h2 = histogram(UF_def);
h2.Normalization = 'probability';
h2.BinWidth = 0.05;
h3 = plot(0.3.*ones(size(0:0.1:0.6)), 0:0.1:0.6, 'k-', 'Linewidth',2.5);
txt = 'VUF_{max} = 0.3 %';
text(0.32,0.3,txt)
legend('VUF after PV Re-phasing (DBFOA)','VUF before PV Re-phasing');
xlabel('VUF (%)')
ylabel('Probability');