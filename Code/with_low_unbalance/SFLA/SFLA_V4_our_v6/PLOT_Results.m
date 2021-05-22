close all;
clear all;
clc;

load('Result_MC_def.mat');
load('Result_MC_our.mat');
[N_data, fla_params] = Load_Parameters();

%% Results
for i=1:fla_params.N_MC
    Cost_Summary_def(i,:) = Result_MC_def(i).Cost;
    Cost_Summary_our(i,:) = Result_MC_our(i).Cost;
end
% Cost_Summary_def(fla_params.N_MC,:) = Result_MC_def(72).Cost;
% Cost_Summary_our(fla_params.N_MC,:) = Result_MC_our(72).Cost;

%%
figure('Color', 'w');
c = colormap(lines(2));


A(:,1) = Cost_Summary_def(:,1);        % some data
A(:,2) = Cost_Summary_our(:,1);        % some data
A(:,3) = NaN;        % some data
A(:,4) = Cost_Summary_def(:,2);        % some data
A(:,5) = Cost_Summary_our(:,2);        % some data
A(:,6) = NaN;        % some data
A(:,7) = Cost_Summary_def(:,3);        % some data
A(:,8) = Cost_Summary_our(:,3);        % some data
A(:,9) = NaN;        % some data
A(:,10) = Cost_Summary_def(:,4);        % some data
A(:,11) = Cost_Summary_our(:,4);        % some data
A(:,12) = NaN;        % some data
A(:,13) = Cost_Summary_def(:,5);        % some data
A(:,14) = Cost_Summary_our(:,5);        % some data
A(:,15) = NaN;        % some data

C = [c; ones(1,3); c; ones(1,3); c; ones(1,3); c; ones(1,3); c; ones(1,3); ];  % this is the trick for coloring the boxes

% regular plot
boxplot(A,'colors', C,'plotstyle', 'compact','labels', {'','1','','','2','','','3','','','4','','','5',''}); % label only two categories
hold on;
for ii = 1:2
    plot(NaN,1,'color', c(ii,:), 'LineWidth', 4);
end
legend({'SFLA - Default', 'SFLA - GSP'});
title('Best Cost');
ylabel('Best cost');
xlabel('Epoch');
set(gca, 'YLim', [0 11]);
print(gcf,'SFLA_V6.png','-dpng','-r900');

%% Identify the median cost for Our case
median_our_it1              = median(Cost_Summary_our);
med_pos_our_after_it1  = Result_MC_our(find(Cost_Summary_our(:,1)==median_our_it1(1,1))).Position(1,:);
[ LF_V_abs_our_it1, UBF_abs_our_it1] = Load_Flow_LG(med_pos_our_after_it1,N_data);

%% Identify the median cost for Our case
median_def_it1              = median(Cost_Summary_def);
med_pos_def_after_it1  = Result_MC_def(find(Cost_Summary_def(:,1)==median_def_it1(1,1))).Position(1,:);
[ LF_V_abs_def_it1, UBF_abs_def_it1] = Load_Flow_LG(med_pos_def_after_it1,N_data);

figure(2);
hold on;
plot(1:63,UBF_abs_our_it1,'r*-','LineWidth',1.5);
plot(1:63,UBF_abs_def_it1,'bo-','LineWidth',1.5);
plot(1:63,N_data.Unbalance_limit.*ones(1,63),'k-','LineWidth',2);
xlim([1 63]);
legend('Proposed SFLA','Default SFLA','Location','NorthWest');
title({'Variation of the Voltage Unbalance Factor',' for proposed and default SFLA algorithm' 'for the solution correspond to median cost after one epoch'});
xlabel('Bus No.');
ylabel('Voltage Unbalance Factor (%) ');
print(gcf,'SFLA_V6_UF.png','-dpng','-r900');

figure(3);
hold on;
plot(1:63,LF_V_abs_our_it1(:,4),'r*-','LineWidth',1.5);
plot(1:63,LF_V_abs_def_it1(:,4),'bo-','LineWidth',1.5);
xlim([1 63]);
legend('Proposed SFLA','Default SFLA','Location','NorthWest');
title({'Variation of Neutral Voltage',' for proposed and default SFLA algorithm',' for the solution correspond to median cost after one epoch'});
xlabel('Bus No.');
ylabel('Neutral Voltage (p.u.)');
print(gcf,'SFLA_V6_NV.png','-dpng','-r900');

figure(4);
hold on;
plot(1:fla_params.MaxIt,mean(Cost_Summary_our),'r*-','LineWidth',2);
plot(1:fla_params.MaxIt,mean(Cost_Summary_def),'bo-','LineWidth',2);
xlabel('# of Epoch');
ylabel('Mean best cost');
title('Variation of mean best cost with number of epoch');
legend('Proposed SFLA','Default SFLA','Location','NorthWest');
print(gcf,'SFLA_V6_Mean_COST.png','-dpng','-r900');