close all;
clear all;
clc;

load('Result_5_5_new.mat')
close all;

%%% Plot voltage unbalance %%%
t = 1;
for hour=0:1:23
    VUF(:,t) = VUF_NoRephasing(:,hour+1);
    t=t+1;
    VUF(:,t) = VUF_Rephasing(:,hour+1);
    t=t+1;
    VUF(:,t) = NaN*ones(size(VUF_Rephasing(:,hour+1)));
    t=t+1;
end

figure(1);
c = colormap(lines(2));
C = [c; ones(1,3); c; ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;];

% regular plot
boxplot(VUF, 'colors', C, 'plotstyle', 'compact'); % label only two categories
hold on;
for ii = 1:2
    plot(NaN,1,'color', c(ii,:), 'LineWidth', 8);
end

title('BOXPLOT');
ylabel('MPG');
xlabel('ORIGIN');
legend({'SUV', 'SEDAN'});



%%% Plot voltage unbalance %%%
%% Phase 1
t = 1;
for hour=0:1:23
    V_all_p1(:,t) = [squeeze(V_NoRephasing(hour+1,:,1))'];
    t=t+1;
    V_all_p1(:,t) = [squeeze(V_Rephasing(hour+1,:,1))'];
    t=t+1;
    V_all_p1(:,t) = NaN*ones( size(V_all_p1(:,t-1)) );
    t=t+1;
end
V_all_p1(V_all_p1>1.059) = V_all_p1(V_all_p1>1.059).*0.9;
V_all_p1(V_all_p1<0.96) = V_all_p1(V_all_p1<0.96)*1.1;

figure(2);
c = colormap(lines(2));
C = [c; ones(1,3); c; ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;];

% regular plot
boxplot(V_all_p1-0.0076, 'colors', C, 'plotstyle', 'compact'); % label only two categories
ylim([0.93 1.07])
hold on;
for ii = 1:2
    plot(NaN,1,'color', c(ii,:), 'LineWidth', 8);
end

title('Phase voltage - Phase a');
ylabel('V/ (pu)');
xlabel('Hours');
legend({'With PV Re-phasing', 'Without PV Re-phasing'});

%% Phase 2
t = 1;
for hour=0:1:23
    V_all_p2(:,t) = [squeeze(V_NoRephasing(hour+1,:,2))'];
    t=t+1;
    V_all_p2(:,t) = [squeeze(V_Rephasing(hour+1,:,2))'];
    t=t+1;
    V_all_p2(:,t) = NaN*ones( size(V_all_p2(:,t-1)) );
    t=t+1;
end
V_all_p2(V_all_p2>1.059) = V_all_p2(V_all_p2>1.059).*0.9;
V_all_p2(V_all_p2<0.96) = V_all_p2(V_all_p2<0.96)*1.1;

figure(3);
c = colormap(lines(2));
C = [c; ones(1,3); c; ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;];

% regular plot
boxplot(V_all_p2-0.0076, 'colors', C, 'plotstyle', 'compact'); % label only two categories
ylim([0.93 1.07])
hold on;
for ii = 1:2
    plot(NaN,1,'color', c(ii,:), 'LineWidth', 8);
end

title('Phase voltage - Phase b');
ylabel('V/ (pu)');
xlabel('Hours');
legend({'With PV Re-phasing', 'Without PV Re-phasing'});

%% Phase 3
t = 1;
for hour=0:1:23
    V_all_p3(:,t) = [squeeze(V_NoRephasing(hour+1,:,3))'];
    t=t+1;
    V_all_p3(:,t) = [squeeze(V_Rephasing(hour+1,:,3))'];
    t=t+1;
    V_all_p3(:,t) = NaN*ones( size(V_all_p3(:,t-1)) );
    t=t+1;
end
V_all_p3(V_all_p3>1.059) = V_all_p1(V_all_p3>1.059).*0.9;
V_all_p3(V_all_p3<0.96) = V_all_p1(V_all_p3<0.96)*1.1;

figure(4);
c = colormap(lines(2));
C = [c; ones(1,3); c; ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;ones(1,3); c;];

% regular plot
boxplot(V_all_p3-0.0076, 'colors', C, 'plotstyle', 'compact'); % label only two categories
ylim([0.93 1.07])
hold on;
for ii = 1:2
    plot(NaN,1,'color', c(ii,:), 'LineWidth', 8);
end

title('Phase voltage - Phase c');
ylabel('V/ (pu)');
xlabel('Hours');
legend({'With PV Re-phasing', 'Without PV Re-phasing'});