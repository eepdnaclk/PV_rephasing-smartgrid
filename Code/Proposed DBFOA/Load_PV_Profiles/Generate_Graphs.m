close all;
clear all;
clc;

load('Result.mat')
figure(1);
hold on;
grid on;
xlabel('Epochs');
ylabel('Best cost');
for i=1:N_MC
    plot(mean(BFCost_our),'r.-', 'Linewidth', 2.0,'MarkerSize',5);
    plot(mean(BFCost_def),'b.-', 'Linewidth', 2.0,'MarkerSize',5);
end
legend('D-Chemotaxis','Classical Chemotaxis');
title('The effect of D-chemotaxis');

Mean_our = mean(BFCost_our);
Mean_default = mean(BFCost_def);