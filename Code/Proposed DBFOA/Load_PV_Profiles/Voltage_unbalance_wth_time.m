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
N_data.Sing_Phase_Load_Power   = xlsread('Data.xlsx', 'Sing_Phase_Load_Power');
N_data.powerfactor             = xlsread('Data.xlsx', 'powerfactor');
N_data.pv_details              = xlsread('Data.xlsx', 'pv_details');

figure(1);
PV_p = [0,0,0,0,0,0,0,0.0200000000000000,0.340000000000000,0.580000000000000,0.790000000000000,0.930000000000000,1,0.990000000000000,0.870000000000000,0.710000000000000,0.510000000000000,0.310000000000000,0.0100000000000000,0,0,0,0,0,0];
bar(0:1:24,PV_p)
set(gca,'xtick',0:24)
xlim([-0.5,23.5]);
xlabel('Hours');
ylabel('Normalized active power');
text(-0.3,0.97,'P_{max}')


figure(2);
Load = [0.1 0.1 0.1 0.1 0.4 0.3 0.4 0.4 0.3 0.3 0.5 0.6 0.7 0.6 0.5 0.6 0.7 0.8 0.9 1 1 0.6 0.5 0.2 0.1];
bar(0:1:24,Load)
set(gca,'xtick',0:24)
xlim([-0.5,23.5]);
xlabel('Hours');
ylabel('Normalized active power');
text(-0.3,0.97,'P_{max}^{a}/P_{max}^{b}/P_{max}^{c}')


for hour = 0:1:24
    tic
    display(strcat('HOUR = ',num2str(hour)));
    
    N_data.pv_scale         = PV_p(hour+1);	
    N_data.load_scale       = Load(hour+1);
    
    % Optimum solutions for each feeder sections...
    N_data.A = Optimimum_PV_Location(N_data,1,14);
    N_data.B = Optimimum_PV_Location(N_data,15,24);
    N_data.C = Optimimum_PV_Location(N_data,25,30);
    N_data.D = Optimimum_PV_Location(N_data,31,38);
    N_data.E = Optimimum_PV_Location(N_data,39,47);
    N_data.F = Optimimum_PV_Location(N_data,48,56);
    N_data.G = Optimimum_PV_Location(N_data,57,62);
    
    for i=1:BF_params.S
        Position_my(i,:)  = [N_data.A(randi(N_data.N_opt_my),:), N_data.B(randi(N_data.N_opt_my),:), N_data.C(randi(N_data.N_opt_my),:), N_data.D(randi(N_data.N_opt_my),:), N_data.E(randi(N_data.N_opt_my),:), N_data.F(randi(N_data.N_opt_my),:), N_data.G(randi(N_data.N_opt_my),:)];
    end
    
    Best_our                    = Run_BF_my(BF_params, Position_my, N_data);
    BFCost_cost(hour+1,:)       = Best_our.Cost';
    BFCost_position(hour+1,:)   = Best_our.Position';
    toc
    

    [ V, VUF]           = Load_Flow_LG(N_data.pv_details(:,3), N_data);
    mean_VUF(hour+1)    = mean(VUF);
    max_VUF(hour+1)     = max(VUF);

    [ V_DBFOA, VUF_DBFOA]   = Load_Flow_LG(BFCost_position(hour+1,:), N_data);
    mean_VUF_DBFOA(hour+1)  = mean(VUF_DBFOA);
    max_VUF_DBFOA(hour+1)   = max(VUF_DBFOA);    
end

for hour=0:1:24
    N_data.pv_scale         = PV_p(hour+1)+0.0001;	
    N_data.load_scale       = Load(hour+1)+0.0001;
    
    [ V_t, VUF_t]           = Load_Flow_LG(N_data.pv_details(:,3), N_data);
    V_NoRephasing(hour+1,:,:,:) = V_t;
    VUF_NoRephasing(:,hour+1) = VUF_t;
    
    [ V_t, VUF_t]   = Load_Flow_LG(BFCost_position(hour+1,:), N_data);
    V_Rephasing(hour+1,:,:,:) = V_t;
    VUF_Rephasing(:,hour+1) = VUF_t;
end

data = {VUF_NoRephasing(:,1:25), VUF_Rephasing(:,1:25)}; 
boxplotGroup(data, 'PrimaryLabels', {'WR' 'R'}, ...
  'SecondaryLabels',{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24'}, 'InterGroupSpace', 2)


 figure(2);
 t=0:24;
 bar(t,[mean(VUF_NoRephasing)' mean(VUF_Rephasing)'])
 xlabel('Hours')
 ylabel('Mean Voltage Unbalance')
 set(gca,'XTick',0:24)
 xlim([-0.5 24.5])
 
 figure(3)
 hold on
 h=12;
 plot(0:62,VUF_NoRephasing(:,h+1),'ro-','Linewidth',2,'MarkerSize',3)
 plot(0:62,VUF_Rephasing(:,h+1),'bo-','Linewidth',2,'MarkerSize',3)
 set(gca,'XTick',0:3:62)
 xlim([0 62]);
 grid on;
 xlabel('Busbar');
 legend('Default PV configuration','After PV rephasing');
 ylabel('Voltage Unbalance (%)');
 set(gcf,'Position',[100 100 500 300])
 
 %%
 figure(4)
 hold on
 h=7;
 V=squeeze(V_NoRephasing(h+1,:,:,:));
 plot(0:62,V(:,1),'r-','Linewidth',2,'MarkerSize',3)
 plot(0:62,V(:,2),'b-','Linewidth',2,'MarkerSize',3)
 plot(0:62,V(:,3),'g-','Linewidth',2,'MarkerSize',3)
 V=squeeze(V_Rephasing(h+1,:,:,:));
 plot(0:62,V(:,1),'ro-','Linewidth',2,'MarkerSize',3)
 plot(0:62,V(:,2),'bo-','Linewidth',2,'MarkerSize',3)
 plot(0:62,V(:,3),'go-','Linewidth',2,'MarkerSize',3)
 set(gca,'XTick',0:3:62)
 xlim([0 62]);
 %ylim([0.94 1.06])
 grid on;
 xlabel('Busbar');
 legend('Default: Va','Default: Vb','Default: Vc','Rephased: Va','Rephased: Vb','Rephased: Vc','Location','NorthEastOutside');
 ylabel('Phase voltage (pu)');
 set(gcf,'Position',[100 100 600 300])