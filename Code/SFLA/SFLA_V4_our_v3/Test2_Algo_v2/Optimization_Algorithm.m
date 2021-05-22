close all;
clear all;
clc;

%% Chaminda Bandara - Last Update: 6th January 2019
%% Optimization algorithm - V1

%% Clear previous content in the exel worksheet ...
filename = 'E:\Chaminda\14. GSP\2_SFLA_Algorithm\SFLA_V4_our\Test2_Algo_v2\Data.xlsx';
Excel = actxserver('Excel.Application');
Workbook = Excel.Workbooks.Open(filename);
Workbook.Worksheets.Item('pv_details').Range('D1:O26').ClearContents  
Workbook.Save;
Excel.Workbook.Close;
invoke(Excel, 'Quit');
delete(Excel)

%% Load default PV data
pv_details 		= xlsread('Data.xlsx', 'pv_details');
xlswrite('Data.xlsx',pv_details(:,1:3),'pv_details');
load_details 	= xlsread('Data.xlsx', 'Sing_Phase_Load_Power');

%% Default load flow analysis ... (input argument = 1 ---> Default ---> from column 3-pv phase)
[LF_V, Unbalance_factor]    = Load_Flow_LG();

%% Plot load flow results
figure(1);
subplot(2,1,1); hold on; grid on; plot(1:63,LF_V(:,1:3),'-o','Linewidth',2.0); xlim([1 63]); 
xlabel('Node number'); ylabel('Phase voltage/ (V)'); 
legend('Phase 1 (A)','Phase 2 (B)','Phase 3 (C)'); title('Phase Voltages - Stage (0)')
subplot(2,1,2); hold on; grid on; plot(1:63,Unbalance_factor,'-o', 'Linewidth', 1.5); ylim([0 1]);xlim([1 63]);
title('Voltage Unlabance Factor - Stage (0)'); xlabel('Node Number'); ylabel('Unbalance Factor (%)');

%%%%%%%%%%%%%%%%%%%%%%% First Optimization Region %%%%%%%%%%%%%%%%%%%%%%%%%
%% First identify the region here ...
Start_Bus = 12;
Stop_Bus  = 25;
[pv_details, min_error] = Optimimum_PV_Location(pv_details, load_details, LF_V, Start_Bus, Stop_Bus);
xlswrite('Data.xlsx',pv_details,'pv_details');
[LF_V, Unbalance_factor]    = Load_Flow_LG();

%% Load flow result
figure(2);
subplot(2,1,1); hold on; grid on;  plot(1:63,squeeze(LF_V(:,1:3)),'-o','Linewidth',2.0); xlim([1 63]); 
xlabel('Node number'); ylabel('Phase voltage/ (V)'); legend('Phase 1 (A)','Phase 2 (B)','Phase 3 (C)'); title('Phase Voltages - Stage (1)')
subplot(2,1,2); hold on; grid on;  plot(1:63,Unbalance_factor,'-o','Linewidth', 1.5);ylim([0 1]); xlim([1 63]);
title('Voltage Unlabance Factor - Stage (1)'); xlabel('Node Number'); ylabel('Unbalance Factor (%)'); 

%%%%%%%%%%%%%%%%%%%%%%% First Optimization Region %%%%%%%%%%%%%%%%%%%%%%%%%
%% First identify the region here ...
Start_Bus = 40;
Stop_Bus  = 48;
[pv_details, min_error] = Optimimum_PV_Location(pv_details, load_details, LF_V, Start_Bus, Stop_Bus);
xlswrite('Data.xlsx',pv_details,'pv_details');
[LF_V, Unbalance_factor]    = Load_Flow_LG();

%% Load flow result
figure(3);
subplot(2,1,1); hold on; grid on; plot(1:63,squeeze(LF_V(:,1:3)),'-o','Linewidth',2.0); xlim([1 63]); 
xlabel('Node number'); ylabel('Phase voltage/ (V)'); legend('Phase 1 (A)','Phase 2 (B)','Phase 3 (C)');  title('Phase Voltages - Stage (2)')
subplot(2,1,2); hold on; grid on; plot(1:63,Unbalance_factor,'-o','Linewidth', 1.5);ylim([0 1]); xlim([1 63]);
xlabel('Node Number'); ylabel('Unbalance Factor (%)'); title('Voltage Unlabance Factor - Stage (2)');
