clear all;
close all;
clc;

Max_epoch = 250;
load('BF1.mat')
load('DGA1.mat');DGA1(1)=13.66;
load('SFLA1.mat');
load('Heuristic.mat')

BF1(end:Max_epoch) = BF1(end);

figure(1);
hold on;
grid on;
plot(BF1(1:Max_epoch),'ro-','LineWidth',2,'Markersize',1);
plot(DGA1(1:5:5*Max_epoch),'bo-','LineWidth',2,'Markersize',1);
plot(SFLA1,'ko-','LineWidth',2,'Markersize',1);
plot(mean(Heuristic'),'mo-','LineWidth',2,'Markersize',1);
ylim([0.4 14])
ylabel('Best cost');
xlabel('Epochs');
legend('Proposed DBFOA','DGA','SFLA','Heuristic');
