clear all;
close all;
clc;

%Author: Chaminda Bandara
%Date 14th - January - 2019
%V1

%% Vatiables
Penalty_F       = 1;		% Default = 1.00
Unbalance_limit = 0.4;
population_size = 6;
mutation_ratio  = 0.07;     % Default = 0.03
count           = 500;

%% Initial PV Combination
pv_details  = xlsread('Data.xlsx', 'pv_details');
temp        = pv_details(:,3);
PV_phase    = randi(3,length(temp),population_size);

% Initialize Variable
[temp1, temp2]      = Load_Flow_LG(PV_phase(:,1));
LF_V_abs            = zeros([population_size, size(temp1)]);
Unbalance_factor    = zeros([size(temp2),population_size]);
fitness_evolution   = zeros(count,1);

while count
    %% Initial load flow
    for i=1: population_size
        % Run Load flow analysis
        [A, B] = Load_Flow_LG(PV_phase(:,i));
        LF_V_abs(i,:,:) = A;
        Unbalance_factor(:,i) = B;
        
        % Calculate fitness function
        Fitness_fun(i,1)= find_fitness(Unbalance_factor(:,i), Penalty_F, Unbalance_limit);
        
        %% Print progree
        fprintf('Itteration: %d <-----> population: %d \n',count,i);
    end
    
    %% parent selection
    beta= 10;
    raw = exp((-1*beta/max(Fitness_fun)).*Fitness_fun);
    P   = raw./sum(raw);
    
     C          = cumsum(P);
     X          = 1:population_size;
     rand_num   = rand(population_size,1);
     
    for J=1:population_size
        parent_ID(J,1) = X(1,1+length(C(C<rand_num(J,1))));
    end
    
    %% Crossover Operator
    PV_phase = find_crossover(PV_phase);
    
    %% Mutation Operator
    PV_phase = find_mutation( PV_phase,mutation_ratio);
    
    %% find minimum fitness value
    [fitness_evolution(length(fitness_evolution)-count+1,1), min_loc] = min(Fitness_fun);
    unbalance_evolution(:,length(fitness_evolution)-count+1) = Unbalance_factor(:,min_loc);
    
    %% update count
    count = count-1;
end

%% Plot Fitness function
figure(1);
hold on;
plot(1:length(fitness_evolution),fitness_evolution,'r-o','LineWidth',1.5);
xlabel('Itteration');
ylabel('Filtness Function');

%% Plot minimum unbalance factor 
[min_fit,min_loc_fit] = min(fitness_evolution);
figure(2);
hold on; grid on;
title('Voltage Unbalance before and after re-phasing');
plot(1:63,unbalance_evolution(:,min_loc_fit),'r-o','LineWidth',1.5);
xlim([1 63]);
xlabel('Bus No.');
ylabel('Voltage Unbalance Factor - (%)');

[~, default_UF]      = Load_Flow_LG(temp);
plot(1:63,default_UF,'b-o','LineWidth',1.5);
legend('Before PV Re-Phasing', 'After PV Re-Phasing');

%% Draw Histogram
% Examples
A={default_UF, unbalance_evolution(:,min_loc_fit)};
figure();
hold on;
title('Voltage Unbalance before and after Re-Phasing');
nhist(A,'legend',{'Before PV Re-Phasing','After PV Re-Phasing'});
figure();
nhist(A,'color',[.3 .8 .3],'separate','median','noerror', 'legend',{'Before PV Re-Phasing','After PV Re-Phasing'},'separate');