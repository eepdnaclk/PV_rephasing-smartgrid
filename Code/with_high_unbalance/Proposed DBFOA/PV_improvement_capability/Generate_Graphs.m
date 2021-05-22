close all;
clear all;
clc;


load('V_VUF_with.mat');

Vmax = Vmax+0.0123;
x = [1	2	3	4	5	6	7	8	9	10	11	12	14	16	18	20	22	24	26	28	30];

%% With PV Re-phasing
figure(1);
hold on;
grid on;
h1 = boxplot(Vmax,'positions',x,'Labels',{'1','2','3','4','5','6','7','8','9','10','11','12','14','16','18','20','22','24','26','28','30'});
set(h1,{'linew'},{1.3});
xlabel('No. of new rooftop PV systems');
ylabel('Maximum phase voltage (pu)')

figure(2);
hold on;
grid on;
h2 = boxplot(VUFmax,'positions',x,'Labels',{'1','2','3','4','5','6','7','8','9','10','11','12','14','16','18','20','22','24','26','28','30'});
ylim([0 1]);
set(h2,{'linew'},{1.3});
xlabel('No. of new rooftop PV systems');
ylabel('Maximum voltage unbalance factor')

%% Without PV re-phasing
load('V_VUF_without.mat');
figure(3);
hold on;
grid on;
h3 = boxplot(Vmax,'positions',x,'Labels',{'1','2','3','4','5','6','7','8','9','10','11','12','14','16','18','20','22','24','26','28','30'});
set(h3,{'linew'},{1.3});
xlabel('No. of new rooftop PV systems');
ylabel('Maximum phase voltage (pu)')

figure(4);
hold on;
grid on;
h4 = boxplot(VUFmax,'positions',x,'Labels',{'1','2','3','4','5','6','7','8','9','10','11','12','14','16','18','20','22','24','26','28','30'});
ylim([0 3]);
set(h4,{'linew'},{1.3});
xlabel('No. of new rooftop PV systems');
ylabel('Maximum voltage unbalance factor')